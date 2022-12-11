import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/models/answer.dart';
import 'package:thinking_capp/models/paginator.dart';
import 'package:thinking_capp/models/user.dart';
import 'package:thinking_capp/services/answers_store.dart';
import 'package:thinking_capp/services/auth.dart';

class AnswersDbService extends GetxService {
  final _answersStore = Get.find<AnswersStore>();
  MyUser get _currentUser => Get.find<AuthService>().currentUser;

  final _questionsRef = FirebaseFirestore.instance.collection('questions');
  final _answersGroup = FirebaseFirestore.instance.collectionGroup('answers');

  Future<PaginationData<Answer>> getAnswersForQuestion(
    String questionId,
    String orderBy,
    DocumentSnapshot? startAfterDoc,
  ) async {
    var query = _questionsRef
        .doc(questionId)
        .collection('answers')
        .orderBy(orderBy, descending: true);
    if (startAfterDoc != null) {
      query = query.startAfterDocument(startAfterDoc);
    }
    final snapshot = await query.limit(10).get();
    final answers = <Answer>[];
    for (final doc in snapshot.docs) {
      answers.add(await _answersStore.getAnswer(
        doc.id,
        doc.reference.parent.parent!.id,
        doc.data(),
        fromFirebase: true,
      ));
    }
    if (answers.isEmpty) {
      return PaginationData(
        items: [],
        cursor: startAfterDoc,
        reachedEnd: true,
      );
    }
    return PaginationData(
      items: answers,
      cursor: snapshot.docs.last,
      reachedEnd: answers.length < 10,
    );
  }

  Future<List<Answer>> getAnswersByPoster(String userId) async {
    final snapshot = await _answersGroup
        .where('poster', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();
    final answers = <Answer>[];
    for (final doc in snapshot.docs) {
      final answer = await _answersStore.getAnswer(
        doc.id,
        doc.reference.parent.parent!.id,
        doc.data(),
        fromFirebase: true,
      );
      answers.add(answer);
    }
    return answers;
  }

  Future<Answer> postAnswer(
    String questionId,
    String text,
    List<String> photoUrls,
  ) async {
    final timestamp = Timestamp.now();
    final ref = await _questionsRef.doc(questionId).collection('answers').add({
      'text': text,
      'photoUrls': photoUrls,
      'poster': _currentUser.id,
      'upvotedBy': [],
      'downvotedBy': [],
      'numVotes': 0,
      'timestamp': timestamp,
    });
    // update question numAnswers count
    await _questionsRef
        .doc(questionId)
        .update({'numAnswers': FieldValue.increment(1)});
    final answer = Answer(
      id: ref.id,
      questionId: questionId,
      text: text.obs,
      photoUrls: photoUrls.obs,
      poster: _currentUser,
      myVote: Rx<bool?>(null),
      timestamp: timestamp.toDate(),
    );
    _answersStore.putAnswer(answer);
    return answer;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/models/answer.dart';
import 'package:thinking_capp/models/paginator.dart';
import 'package:thinking_capp/models/user.dart';
import 'package:thinking_capp/services/auth.dart';
import 'package:thinking_capp/services/users_db.dart';
import 'package:thinking_capp/services/voting.dart';

class AnswersDbService extends GetxService {
  final _usersDb = Get.find<UsersDbService>();
  final _voting = Get.find<VotingService>();
  MyUser get _currentUser => Get.find<AuthService>().currentUser;

  final _questionsRef = FirebaseFirestore.instance.collection('questions');
  final _answersGroup = FirebaseFirestore.instance.collectionGroup('answers');

  Future<Answer> _answerFromDoc(DocumentSnapshot<Map> doc) async {
    final data = doc.data()!;
    final poster = await _usersDb.getUser(data['poster']);
    bool? myVote;
    if (data['upvotedBy'].contains(_currentUser.id)) {
      myVote = true;
    } else if (data['downvotedBy'].contains(_currentUser.id)) {
      myVote = false;
    }
    return Answer(
      id: doc.id,
      questionId: doc.reference.parent.parent!.id,
      text: data['text'],
      photoUrls: List<String>.from(data['photoUrls']),
      poster: poster,
      numVotes: data['numVotes'],
      myVote: _voting.setMyVote(doc.id, myVote),
      timestamp: data['timestamp'].toDate(),
    );
  }

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
      answers.add(await _answerFromDoc(doc));
    }
    if (answers.isEmpty) return PaginationData([], startAfterDoc, true);
    return PaginationData(
      answers,
      snapshot.docs.last,
      answers.length < 10,
    );
  }

  Future<List<Answer>> getAnswersByPoster(String userId) async {
    final snapshot = await _answersGroup
        .where('poster', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();
    final answers = <Answer>[];
    for (final doc in snapshot.docs) {
      final answer = await _answerFromDoc(doc);
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
    return Answer(
      id: ref.id,
      questionId: questionId,
      text: text,
      photoUrls: photoUrls,
      poster: _currentUser,
      numVotes: 0,
      myVote: _voting.setMyVote(ref.id, null),
      timestamp: timestamp.toDate(),
    );
  }
}

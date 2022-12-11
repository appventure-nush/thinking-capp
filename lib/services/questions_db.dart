import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/models/paginator.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/services/auth.dart';
import 'package:thinking_capp/services/questions_store.dart';

class QuestionsDbService extends GetxService {
  final _questionsStore = Get.find<QuestionsStore>();
  String get _currentUserId => Get.find<AuthService>().currentUser.id;

  final _questionsRef = FirebaseFirestore.instance.collection('questions');

  Future<PaginationData<Question>> loadFeed({
    required String sortBy,
    required DocumentSnapshot? startAfterDoc,
    required bool sortDescending,
    required List<String>? tags, // if tags is null, load all questions
  }) async {
    var query = _questionsRef
        .where('tags', arrayContainsAny: tags)
        .orderBy(sortBy, descending: sortDescending);
    if (startAfterDoc != null) {
      query = query.startAfterDocument(startAfterDoc);
    }
    final snapshot = await query.limit(10).get();
    final questions = <Question>[];
    for (final doc in snapshot.docs) {
      questions.add(_questionsStore.getQuestion(
        doc.id,
        doc.data(),
        fromFirebase: true,
      ));
    }
    if (questions.isEmpty) {
      return PaginationData(
        items: [],
        cursor: startAfterDoc,
        reachedEnd: true,
      );
    }
    return PaginationData(
      items: questions,
      cursor: snapshot.docs.last,
      reachedEnd: questions.length < 10,
    );
  }

  Future<List<Question>> getQuestionsByIds(List<String> questionIds) async {
    final questions = <Question>[];
    for (final id in questionIds) {
      final doc = await _questionsRef.doc(id).get();
      questions.add(_questionsStore.getQuestion(
        doc.id,
        doc.data()!,
        fromFirebase: true,
      ));
    }
    return questions;
  }

  Future<List<Question>> getQuestionsByPoster(String userId) async {
    final snapshot = await _questionsRef
        .where('poster', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();
    final questions = <Question>[];
    for (final doc in snapshot.docs) {
      questions.add(_questionsStore.getQuestion(
        doc.id,
        doc.data(),
        fromFirebase: true,
      ));
    }
    return questions;
  }

  Future<List<Question>> getVotedQuestions(String userId, bool vote) async {
    final snapshot = await _questionsRef
        .where(vote ? 'upvotedBy' : 'downvotedBy', arrayContains: userId)
        .orderBy('timestamp', descending: true)
        .get();
    final questions = <Question>[];
    for (final doc in snapshot.docs) {
      questions.add(_questionsStore.getQuestion(
        doc.id,
        doc.data(),
        fromFirebase: true,
      ));
    }
    return questions;
  }

  Future<Question> postQuestion(
    String title,
    String text,
    List<String> photoUrls,
    List<String> tags,
  ) async {
    final timestamp = Timestamp.now();
    final ref = await _questionsRef.add({
      'title': title,
      'text': text,
      'photoUrls': photoUrls,
      'tags': tags,
      'poster': _currentUserId,
      'upvotedBy': [],
      'downvotedBy': [],
      'numVotes': 0,
      'numAnswers': 0,
      'timestamp': timestamp,
    });
    final question = Question(
      id: ref.id,
      title: title.obs,
      text: text.obs,
      photoUrls: photoUrls.obs,
      tags: tags.obs,
      byMe: true,
      myVote: Rx<bool?>(null),
      numAnswers: 0,
      timestamp: timestamp.toDate(),
    );
    _questionsStore.putQuestion(question);
    return question;
  }

  Future<void> editQuestion(
    String id,
    String title,
    String text,
    List<String> photoUrls,
    List<String> tags,
  ) async {
    await _questionsRef.doc(id).update({
      'title': title,
      'text': text,
      'photoUrls': photoUrls,
      'tags': tags,
    });
  }
}

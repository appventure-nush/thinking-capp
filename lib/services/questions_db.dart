import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/models/paginator.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/services/auth.dart';
import 'package:thinking_capp/services/voting.dart';

class QuestionsDbService extends GetxService {
  final _voting = Get.find<VotingService>();
  String get _currentUserId => Get.find<AuthService>().currentUser.id;

  final _questionsRef = FirebaseFirestore.instance.collection('questions');

  Question _questionFromDoc(DocumentSnapshot<Map> doc) {
    final data = doc.data()!;
    bool? myVote;
    if (data['upvotedBy'].contains(_currentUserId)) {
      myVote = true;
    } else if (data['downvotedBy'].contains(_currentUserId)) {
      myVote = false;
    }
    return Question(
      id: doc.id,
      title: data['title'],
      text: data['text'],
      photoUrls: List<String>.from(data['photoUrls']),
      tags: List<String>.from(data['tags']),
      byMe: data['poster'] == _currentUserId,
      numVotes: data['numVotes'],
      myVote: _voting.setMyVote(doc.id, myVote),
      numAnswers: data['numAnswers'],
      timestamp: data['timestamp'].toDate(),
    );
  }

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
      questions.add(_questionFromDoc(doc));
    }
    if (questions.isEmpty) return PaginationData([], startAfterDoc, true);
    return PaginationData(
      questions,
      snapshot.docs.last,
      questions.length < 10,
    );
  }

  Future<List<Question>> getQuestionsByIds(List<String> questionIds) async {
    final questions = <Question>[];
    for (final id in questionIds) {
      final doc = await _questionsRef.doc(id).get();
      questions.add(_questionFromDoc(doc));
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
      questions.add(_questionFromDoc(doc));
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
      questions.add(_questionFromDoc(doc));
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
    return Question(
      id: ref.id,
      title: title,
      text: text,
      photoUrls: photoUrls,
      tags: tags,
      byMe: true,
      numVotes: 0,
      myVote: _voting.setMyVote(ref.id, null),
      numAnswers: 0,
      timestamp: timestamp.toDate(),
    );
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

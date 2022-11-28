import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/models/answer.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/models/user.dart';
import 'package:thinking_capp/services/auth.dart';
import 'package:thinking_capp/services/store.dart';
import 'package:thinking_capp/services/users_db.dart';

class PaginationData<T> {
  List<T> data;
  DocumentSnapshot? lastDoc;
  bool reachedEnd;

  PaginationData(this.data, this.lastDoc, this.reachedEnd);
}

class QuestionsDbService extends GetxService {
  MyUser get _user => Get.find<AuthService>().currentUser;
  final _usersDb = Get.find<UsersDbService>();
  final _store = Get.find<Store>();

  final _questionsRef = FirebaseFirestore.instance.collection('questions');
  final _answersGroup = FirebaseFirestore.instance.collectionGroup('answers');

  Question _questionFromDoc(DocumentSnapshot<Map> doc) {
    final data = doc.data()!;
    bool? myVote;
    if (data['upvotedBy'].contains(_user.id)) {
      myVote = true;
    } else if (data['downvotedBy'].contains(_user.id)) {
      myVote = false;
    }
    if (_store.myVotes.containsKey(doc.id)) {
      _store.myVotes[doc.id]!.value = myVote;
    } else {
      _store.myVotes[doc.id] = Rx<bool?>(myVote);
    }
    return Question(
      id: doc.id,
      title: data['title'],
      text: data['text'],
      photoUrls: List<String>.from(data['photoUrls']),
      tags: List<String>.from(data['tags']),
      byMe: data['poster'] == _user.id,
      numVotes: data['numVotes'],
      myVote: _store.myVotes[doc.id]!,
      numAnswers: data['numAnswers'],
      timestamp: data['timestamp'].toDate(),
    );
  }

  Future<Answer> _answerFromDoc(DocumentSnapshot<Map> doc) async {
    final data = doc.data()!;
    final poster = await _usersDb.getUser(data['poster']);
    bool? myVote;
    if (data['upvotedBy'].contains(_user.id)) {
      myVote = true;
    } else if (data['downvotedBy'].contains(_user.id)) {
      myVote = false;
    }
    if (_store.myVotes.containsKey(doc.id)) {
      _store.myVotes[doc.id]!.value = myVote;
    } else {
      _store.myVotes[doc.id] = Rx<bool?>(myVote);
    }
    return Answer(
      id: doc.id,
      questionId: doc.reference.parent.parent!.id,
      text: data['text'],
      photoUrls: List<String>.from(data['photoUrls']),
      poster: poster,
      numVotes: data['numVotes'],
      myVote: _store.myVotes[doc.id]!,
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
      'poster': _user.id,
      'upvotedBy': [],
      'downvotedBy': [],
      'numVotes': 0,
      'numAnswers': 0,
      'timestamp': timestamp,
    });
    _store.myVotes[ref.id] = Rx<bool?>(null);
    return Question(
      id: ref.id,
      title: title,
      text: text,
      photoUrls: photoUrls,
      tags: tags,
      byMe: true,
      numVotes: 0,
      myVote: _store.myVotes[ref.id]!,
      numAnswers: 0,
      timestamp: timestamp.toDate(),
    );
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
      'poster': _user.id,
      'upvotedBy': [],
      'downvotedBy': [],
      'numVotes': 0,
      'timestamp': timestamp,
    });
    // update question numAnswers count
    await _questionsRef
        .doc(questionId)
        .update({'numAnswers': FieldValue.increment(1)});
    _store.myVotes[ref.id] = Rx<bool?>(null);
    return Answer(
      id: ref.id,
      questionId: questionId,
      text: text,
      photoUrls: photoUrls,
      poster: _user,
      numVotes: 0,
      myVote: _store.myVotes[ref.id]!,
      timestamp: timestamp.toDate(),
    );
  }

  Stream<int> numVotesStream(String questionId, {String? answerId}) {
    var ref = _questionsRef.doc(questionId);
    if (answerId != null) {
      ref = ref.collection('answers').doc(answerId);
    }
    return ref.snapshots().map<int>((doc) {
      return doc.data()!['numVotes'];
    });
  }

  Future<void> upvote(
    String questionId, {
    String? answerId,
    required bool removeDownvote,
  }) async {
    var ref = _questionsRef.doc(questionId);
    if (answerId != null) {
      ref = ref.collection('answers').doc(answerId);
    }
    await ref.update({
      'upvotedBy': FieldValue.arrayUnion([_user.id]),
      if (removeDownvote) 'downvotedBy': FieldValue.arrayRemove([_user.id]),
      'numVotes': FieldValue.increment(removeDownvote ? 2 : 1),
    });
  }

  Future<void> downvote(
    String questionId, {
    String? answerId,
    required bool removeUpvote,
  }) async {
    var ref = _questionsRef.doc(questionId);
    if (answerId != null) {
      ref = ref.collection('answers').doc(answerId);
    }
    await ref.update({
      'downvotedBy': FieldValue.arrayUnion([_user.id]),
      if (removeUpvote) 'upvotedBy': FieldValue.arrayRemove([_user.id]),
      'numVotes': FieldValue.increment(removeUpvote ? -2 : -1),
    });
  }

  Future<void> removeVote(
    String questionId, {
    String? answerId,
    required bool oldVote,
  }) async {
    var ref = _questionsRef.doc(questionId);
    if (answerId != null) {
      ref = ref.collection('answers').doc(answerId);
    }
    await ref.update({
      if (oldVote) 'upvotedBy': FieldValue.arrayRemove([_user.id]),
      if (!oldVote) 'downvotedBy': FieldValue.arrayRemove([_user.id]),
      'numVotes': FieldValue.increment(oldVote ? -1 : 1),
    });
  }
}

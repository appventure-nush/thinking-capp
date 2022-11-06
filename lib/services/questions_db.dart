import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/models/answer.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/models/user.dart';
import 'package:thinking_capp/services/auth.dart';
import 'package:thinking_capp/services/users_db.dart';

class QuestionsDbService extends GetxService {
  AppUser get _user => Get.find<AuthService>().currentUser;
  final _usersDb = Get.find<UsersDbService>();

  final _questionsRef = FirebaseFirestore.instance.collection('questions');

  Future<Question> _questionFromDoc(DocumentSnapshot<Map> doc) async {
    final poster = await _usersDb.getUser(doc['poster']);
    final data = doc.data()!;
    bool? myVote;
    if (data['upvotedBy'].contains(_user.id)) {
      myVote = true;
    } else if (data['downvotedBy'].contains(_user.id)) {
      myVote = false;
    }
    return Question(
      id: doc.id,
      title: data['title'],
      text: data['text'],
      photoUrls: List<String>.from(data['photoUrls']),
      tags: List<String>.from(data['tags']),
      poster: poster,
      upvotes: data['upvotedBy'].length - data['downvotedBy'].length,
      myVote: myVote,
      timestamp: data['timestamp'].toDate(),
    );
  }

  Future<List<Question>> getQuestions(DateTime startAfterTimestamp) async {
    final snapshot = await _questionsRef
        .orderBy('timestamp', descending: true)
        .limit(10)
        .startAfter([Timestamp.fromDate(startAfterTimestamp)]).get();
    final questions = <Question>[];
    for (final doc in snapshot.docs) {
      questions.add(await _questionFromDoc(doc));
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
      'timestamp': timestamp,
    });
    return Question(
      id: ref.id,
      title: title,
      text: text,
      photoUrls: photoUrls,
      tags: tags,
      poster: _user,
      upvotes: 0,
      myVote: null,
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
      'timestamp': timestamp,
    });
    return Answer(
      id: ref.id,
      text: text,
      photoUrls: photoUrls,
      poster: _user,
      upvotes: 0,
      myVote: null,
      timestamp: timestamp.toDate(),
    );
  }
}

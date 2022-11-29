import 'package:algolia/algolia.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/models/answer.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/models/user.dart';
import 'package:thinking_capp/services/auth.dart';
import 'package:thinking_capp/services/store.dart';
import 'package:thinking_capp/services/users_db.dart';

class SearchService extends GetxService {
  final _store = Get.find<Store>();
  final _usersDb = Get.find<UsersDbService>();
  MyUser get _user => Get.find<AuthService>().currentUser;

  final _algolia = Algolia.init(
    applicationId: 'DLCIV2U0R3',
    apiKey: '7b616cdd0eb0d403fae9dc55a21e3371',
  );

  Question _questionFromHitData(Map<String, dynamic> data) {
    bool? myVote;
    if (data['upvotedBy'].contains(_user.id)) {
      myVote = true;
    } else if (data['downvotedBy'].contains(_user.id)) {
      myVote = false;
    }
    final id = data['id'];
    if (_store.myVotes.containsKey(id)) {
      _store.myVotes[id]!.value = myVote;
    } else {
      _store.myVotes[id] = Rx<bool?>(myVote);
    }
    return Question(
      id: id,
      title: data['title'],
      text: data['text'],
      photoUrls: List<String>.from(data['photoUrls']),
      tags: List<String>.from(data['tags']),
      byMe: data['poster'] == _user.id,
      numVotes: data['numVotes'],
      myVote: _store.myVotes[id]!,
      numAnswers: data['numAnswers'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
    );
  }

  Future<Answer> _answerFromHitData(Map<String, dynamic> data) async {
    final poster = await _usersDb.getUser(data['poster']);
    bool? myVote;
    if (data['upvotedBy'].contains(_user.id)) {
      myVote = true;
    } else if (data['downvotedBy'].contains(_user.id)) {
      myVote = false;
    }
    final id = data['id'];
    if (_store.myVotes.containsKey(id)) {
      _store.myVotes[id]!.value = myVote;
    } else {
      _store.myVotes[id] = Rx<bool?>(myVote);
    }
    return Answer(
      id: id,
      questionId: data['questionId'],
      text: data['text'],
      photoUrls: List<String>.from(data['photoUrls']),
      poster: poster,
      numVotes: data['numVotes'],
      myVote: _store.myVotes[id]!,
      timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
    );
  }

  MyUser _userFromHitData(Map<String, dynamic> data) {
    return MyUser(
      id: data['id'],
      name: data['name'],
      photoUrl: data['photoUrl'],
      reputation: data['reputation'],
      followingTags: List<String>.from(data['followingTags']),
      showEverything: data['showEverything'],
      bookmarks: List<String>.from(data['bookmarks']),
    );
  }

  Future<List<Question>> searchQuestions(String query, int page) async {
    final snapshot = await _algolia
        .index('questions')
        .query(query)
        .setHitsPerPage(10)
        .setPage(page)
        .getObjects();
    return snapshot.hits.map((hit) => _questionFromHitData(hit.data)).toList();
  }

  Future<List<Answer>> searchAnswers(String query, int page) async {
    final snapshot = await _algolia
        .index('answers')
        .query(query)
        .setHitsPerPage(10)
        .setPage(page)
        .getObjects();
    return Future.wait(
      snapshot.hits.map((hit) => _answerFromHitData(hit.data)),
    );
  }

  Future<List<MyUser>> searchUsers(String query, int page) async {
    final snapshot = await _algolia
        .index('users')
        .query(query)
        .setHitsPerPage(10)
        .setPage(page)
        .getObjects();
    return snapshot.hits.map((hit) => _userFromHitData(hit.data)).toList();
  }
}

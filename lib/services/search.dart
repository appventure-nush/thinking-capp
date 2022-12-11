import 'package:algolia/algolia.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/models/answer.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/models/user.dart';
import 'package:thinking_capp/services/answers_store.dart';
import 'package:thinking_capp/services/questions_store.dart';

class SearchService extends GetxService {
  final _questionsStore = Get.find<QuestionsStore>();
  final _answersStore = Get.find<AnswersStore>();

  final _algolia = Algolia.init(
    applicationId: 'DLCIV2U0R3',
    apiKey: '7b616cdd0eb0d403fae9dc55a21e3371',
  );

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
    return snapshot.hits
        .map((hit) => _questionsStore.getQuestion(
              hit.data['id'],
              hit.data,
              fromFirebase: false,
            ))
        .toList();
  }

  Future<List<Answer>> searchAnswers(String query, int page) async {
    final snapshot = await _algolia
        .index('answers')
        .query(query)
        .setHitsPerPage(10)
        .setPage(page)
        .getObjects();
    return Future.wait(
      snapshot.hits.map(
        (hit) => _answersStore.getAnswer(
          hit.data['id'],
          hit.data['questionId'],
          hit.data,
          fromFirebase: false,
        ),
      ),
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

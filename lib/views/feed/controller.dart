import 'package:get/get.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/services/cache.dart';
import 'package:thinking_capp/services/questions_db.dart';
import 'package:thinking_capp/views/question/question.dart';

class FeedController extends GetxController {
  final _questionsDb = Get.find<QuestionsDbService>();
  final _cache = Get.find<AppCache>();

  RxList<Question> get feed => _cache.feed;

  void toQuestion(Question question) {
    Get.to(() => QuestionView(question: question));
  }

  Future<void> refreshFeed() async {
    feed.clear();
    feed.addAll(await _questionsDb.getQuestions(DateTime.now()));
  }

  void loadMoreQuestions() async {
    final startAfterTimestamp = feed.last.timestamp;
    feed.addAll(await _questionsDb.getQuestions(startAfterTimestamp));
  }
}

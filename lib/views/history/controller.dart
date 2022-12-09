import 'package:get/get.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/services/auth.dart';
import 'package:thinking_capp/services/questions_db.dart';

class HistoryController extends GetxController {
  final _auth = Get.find<AuthService>();
  final _questionsDb = Get.find<QuestionsDbService>();

  String tab = 'Upvoted';
  final List<Question> upvoted = [];
  final List<Question> downvoted = [];
  final List<Question> bookmarked = [];
  bool loading = false;

  @override
  void onReady() async {
    loading = true;
    update();
    upvoted.addAll(
      await _questionsDb.getVotedQuestions(_auth.currentUser.id, true),
    );
    downvoted.addAll(
      await _questionsDb.getVotedQuestions(_auth.currentUser.id, false),
    );
    bookmarked.addAll(
      await _questionsDb.getQuestionsByIds(_auth.currentUser.bookmarks),
    );
    loading = false;
    update();
  }

  void changeTab(String newTab) {
    tab = newTab;
    update();
  }

  List<Question> get questions {
    if (tab == 'Upvoted') {
      return upvoted;
    } else if (tab == 'Downvoted') {
      return downvoted;
    } else {
      return bookmarked;
    }
  }
}

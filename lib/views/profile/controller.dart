import 'package:get/get.dart';
import 'package:thinking_capp/models/answer.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/services/questions_db.dart';

class ProfileController extends GetxController {
  final _questionsDb = Get.find<QuestionsDbService>();

  String tab = 'Questions';
  final List<Question> questions = [];
  final List<Answer> answers = [];
  bool loading = false;

  final String _userId;

  ProfileController(this._userId);

  @override
  void onReady() async {
    loading = true;
    update();
    questions.addAll(await _questionsDb.getQuestionsByPoster(_userId));
    answers.addAll(await _questionsDb.getAnswersByPoster(_userId));
    loading = false;
    update();
  }

  void changeTab(String newTab) {
    tab = newTab;
    update();
  }
}

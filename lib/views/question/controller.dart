import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/models/answer.dart';
import 'package:thinking_capp/models/paginator.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/services/answers_db.dart';
import 'package:thinking_capp/services/auth.dart';
import 'package:thinking_capp/services/users_db.dart';
import 'package:thinking_capp/views/write_answer/write_answer.dart';
import 'package:thinking_capp/views/write_question/write_question.dart';

class QuestionController extends GetxController {
  final _answersDb = Get.find<AnswersDbService>();
  final _usersDb = Get.find<UsersDbService>();
  final _currentUser = Get.find<AuthService>().currentUser;

  final scrollController = ScrollController();
  String currentTab = 'Top';
  late Paginator<Answer> answersPaginator;
  bool isBookmarked = false;

  RxList<Answer> get answers => answersPaginator.items;

  final Question _question;

  QuestionController(this._question) {
    isBookmarked = _currentUser.bookmarks.contains(_question.id);
    answersPaginator = Paginator<Answer>(
      fetcher: (int page, dynamic cursor) => _answersDb.getAnswersForQuestion(
        _question.id,
        currentTab == 'Top' ? 'numVotes' : 'timestamp',
        cursor,
      ),
    );
  }

  @override
  void onReady() {
    answersPaginator.refresh();
    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels > 0) {
        answersPaginator.nextPage();
      }
    });
  }

  void switchTab(String tab) {
    currentTab = tab;
    answersPaginator.refresh();
  }

  void toggleBookmarkQuestion() async {
    isBookmarked = !isBookmarked;
    update();
    if (isBookmarked) {
      _currentUser.bookmarks.add(_question.id);
      await _usersDb.addBookmark(_question.id);
      Get.rawSnackbar(
        message: 'Question bookmarked',
        backgroundColor: Palette.secondary,
      );
    } else {
      _currentUser.bookmarks.remove(_question.id);
      await _usersDb.removeBookmark(_question.id);
      Get.rawSnackbar(
        message: 'Bookmark removed',
        backgroundColor: Palette.secondary,
      );
    }
  }

  void toEditQuestion() async {
    await Get.to(() => WriteQuestionView(editQuestion: _question));
  }

  void toWriteAnswer() async {
    final answer = await Get.to(WriteAnswerView(questionId: _question.id));
    if (answer != null) {
      answers.insert(0, answer);
    }
  }
}

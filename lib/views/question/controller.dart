import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/models/answer.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/services/auth.dart';
import 'package:thinking_capp/services/questions_db.dart';
import 'package:thinking_capp/services/users_db.dart';
import 'package:thinking_capp/views/write_answer/write_answer.dart';
import 'package:thinking_capp/views/write_question/write_question.dart';

class QuestionController extends GetxController {
  final _questionsDb = Get.find<QuestionsDbService>();
  final _usersDb = Get.find<UsersDbService>();
  final _user = Get.find<AuthService>().currentUser;

  final scrollController = ScrollController();
  String currentTab = 'Top';
  final List<Answer> answers = [];
  DocumentSnapshot? _startAfterDoc;
  bool loadingAnswers = false;
  bool reachedEnd = false;
  bool isBookmarked = false;

  final Question _question;

  QuestionController(this._question) {
    isBookmarked = _user.bookmarks.contains(_question.id);
  }

  @override
  void onReady() {
    refreshAnswers();
    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels > 0) {
        loadMoreAnswers();
      }
    });
  }

  void switchTab(String tab) {
    currentTab = tab;
    refreshAnswers();
  }

  void refreshAnswers() async {
    loadingAnswers = true;
    update();
    answers.clear();
    _startAfterDoc = null;
    reachedEnd = false;
    await loadMoreAnswers();
    loadingAnswers = false;
    update();
  }

  Future<void> loadMoreAnswers() async {
    if (reachedEnd) return;
    final page = await _questionsDb.getAnswersForQuestion(
      _question.id,
      currentTab == 'Top' ? 'numVotes' : 'timestamp',
      _startAfterDoc,
    );
    answers.addAll(page.data);
    _startAfterDoc = page.lastDoc;
    reachedEnd = page.reachedEnd;
    update();
  }

  void toggleBookmarkQuestion() async {
    isBookmarked = !isBookmarked;
    update();
    if (isBookmarked) {
      _user.bookmarks.add(_question.id);
      await _usersDb.addBookmark(_user.id, _question.id);
      Get.rawSnackbar(
        message: 'Question bookmarked',
        backgroundColor: Palette.secondary,
      );
    } else {
      _user.bookmarks.remove(_question.id);
      await _usersDb.removeBookmark(_user.id, _question.id);
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
      update();
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/services/questions_db.dart';
import 'package:thinking_capp/widgets/dialogs/choice_dialog.dart';

class TagController extends GetxController {
  final _questionsDb = Get.find<QuestionsDbService>();

  final scrollController = ScrollController();
  final questions = RxList<Question>();
  DocumentSnapshot? lastDoc;
  bool reachedEnd = false;
  String sortBy = 'timestamp';
  bool loadingMore = false;

  final String _tag;

  TagController(this._tag);

  @override
  void onReady() {
    refreshList();
    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels > 0) {
        // scrolled to bottom
        loadMoreQuestions();
      }
    });
  }

  Future<void> refreshList() async {
    loadingMore = true;
    update();
    questions.clear();
    lastDoc = null;
    reachedEnd = false;
    await loadMoreQuestions();
    loadingMore = false;
    update();
  }

  Future<void> loadMoreQuestions() async {
    if (reachedEnd) return;
    final page = await _questionsDb.loadFeed(
      sortBy: sortBy,
      startAfterDoc: lastDoc,
      sortDescending: sortBy != 'numAnswers',
      tags: [_tag],
    );
    questions.addAll(page.items);
    lastDoc = page.cursor;
    reachedEnd = page.reachedEnd;
  }

  void selectSortBy() async {
    final choice = await Get.dialog(ChoiceDialog(
      title: 'Sort by',
      choices: const ['Most popular', 'Recent', 'Fewest answers'],
      highlightedChoice: sortBy == 'numVotes'
          ? 'Most popular'
          : sortBy == 'timestamp'
              ? 'Recent'
              : 'Fewest answers',
    ));
    if (choice != null) {
      sortBy = choice == 'Most popular'
          ? 'numVotes'
          : choice == 'Recent'
              ? 'timestamp'
              : 'numAnswers';
      await refreshList();
    }
  }
}

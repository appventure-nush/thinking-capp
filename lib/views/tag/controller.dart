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
  String sortBy = 'timestamp';

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

  dynamic initialStartAfter() {
    if (sortBy == 'timestamp') {
      return Timestamp.now();
    }
    if (sortBy == 'numVotes') {
      return 9999;
    }
    if (sortBy == 'numAnswers') {
      return -1; // ascending
    }
    throw 'cannot sort by $sortBy';
  }

  Future<void> refreshList() async {
    questions.clear();
    questions.addAll(
      await _questionsDb.loadFeed(
        sortBy: sortBy,
        startAfter: initialStartAfter(),
        sortDescending: sortBy != 'numAnswers',
        tags: [_tag],
      ),
    );
  }

  void loadMoreQuestions() async {
    final startAfter = sortBy == 'timestamp'
        ? questions.last.timestamp
        : sortBy == 'numVotes'
            ? questions.last.numVotes
            : questions.last.numAnswers;
    questions.addAll(
      await _questionsDb.loadFeed(
        sortBy: sortBy,
        startAfter: startAfter,
        sortDescending: sortBy != 'numAnswers',
        tags: [_tag],
      ),
    );
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

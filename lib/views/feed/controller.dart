import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/services/store.dart';
import 'package:thinking_capp/widgets/dialogs/choice_dialog.dart';

class FeedController extends GetxController {
  final _store = Get.find<Store>();

  RxList<Question> get feed => _store.feed;

  final scrollController = ScrollController();

  @override
  void onReady() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels > 0) {
        // scrolled to bottom
        _store.feedLoadMore();
      }
    });
  }

  Future<void> refreshFeed() => _store.refreshFeed();

  void selectSortBy() async {
    final choice = await Get.dialog(ChoiceDialog(
      title: 'Sort by',
      choices: const ['Most popular', 'Recent', 'Fewest answers'],
      highlightedChoice: _store.feedSortBy == 'numVotes'
          ? 'Most popular'
          : _store.feedSortBy == 'timestamp'
              ? 'Recent'
              : 'Fewest answers',
    ));
    if (choice != null) {
      _store.feedSortBy = choice == 'Most popular'
          ? 'numVotes'
          : choice == 'Recent'
              ? 'timestamp'
              : 'numAnswers';
      await _store.refreshFeed();
    }
  }
}

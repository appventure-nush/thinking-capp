import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/services/cache.dart';
import 'package:thinking_capp/widgets/dialogs/choice_dialog.dart';

class FeedController extends GetxController {
  final _cache = Get.find<AppCache>();

  RxList<Question> get feed => _cache.feed;

  final scrollController = ScrollController();

  @override
  void onReady() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels > 0) {
        // scrolled to bottom
        _cache.feedLoadMore();
      }
    });
  }

  Future<void> refreshFeed() => _cache.refreshFeed();

  void selectSortBy() async {
    final choice = await Get.dialog(ChoiceDialog(
      title: 'Sort by',
      choices: const ['Most popular', 'Recent', 'Fewest answers'],
      highlightedChoice: _cache.feedSortBy == 'numVotes'
          ? 'Most popular'
          : _cache.feedSortBy == 'timestamp'
              ? 'Recent'
              : 'Fewest answers',
    ));
    if (choice != null) {
      _cache.feedSortBy = choice == 'Most popular'
          ? 'numVotes'
          : choice == 'Recent'
              ? 'timestamp'
              : 'numAnswers';
      await _cache.refreshFeed();
    }
  }
}

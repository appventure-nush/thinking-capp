import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/models/paginator.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/services/auth.dart';
import 'package:thinking_capp/services/questions_db.dart';
import 'package:thinking_capp/widgets/dialogs/choice_dialog.dart';

class FeedController extends GetxController {
  final _currentUser = Get.find<AuthService>().currentUser;
  final _questionsDb = Get.find<QuestionsDbService>();

  late Paginator<Question> feedPaginator;
  String feedSortBy = 'timestamp';

  RxList<Question> get feed => feedPaginator.items;

  final scrollController = ScrollController();

  FeedController() {
    feedPaginator = Paginator(
      fetcher: (page, cursor) {
        return _questionsDb.loadFeed(
          sortBy: feedSortBy,
          startAfterDoc: cursor,
          sortDescending: feedSortBy != 'numAnswers',
          tags: _currentUser.showEverything ? null : _currentUser.followingTags,
        );
      },
    );
  }

  @override
  void onReady() {
    feedPaginator.refresh();
    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels > 0) {
        // scrolled to bottom
        feedPaginator.nextPage();
      }
    });
  }

  Future<void> refreshFeed() => feedPaginator.refresh();

  void selectSortBy() async {
    final choice = await Get.dialog(ChoiceDialog(
      title: 'Sort by',
      choices: const ['Most popular', 'Recent', 'Fewest answers'],
      highlightedChoice: feedSortBy == 'numVotes'
          ? 'Most popular'
          : feedSortBy == 'timestamp'
              ? 'Recent'
              : 'Fewest answers',
    ));
    if (choice != null) {
      feedSortBy = choice == 'Most popular'
          ? 'numVotes'
          : choice == 'Recent'
              ? 'timestamp'
              : 'numAnswers';
      await feedPaginator.refresh();
    }
  }
}

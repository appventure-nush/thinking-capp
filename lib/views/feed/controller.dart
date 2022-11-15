import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/services/cache.dart';
import 'package:thinking_capp/services/questions_db.dart';
import 'package:thinking_capp/views/question/question.dart';
import 'package:thinking_capp/widgets/dialogs/choice_dialog.dart';

class FeedController extends GetxController {
  final _questionsDb = Get.find<QuestionsDbService>();
  final _cache = Get.find<AppCache>();

  RxList<Question> get feed => _cache.feed;

  // List<String> tags = [];
  String sortBy = 'timestamp';

  void toQuestion(Question question) {
    Get.to(() => QuestionView(question: question));
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

  Future<void> refreshFeed() async {
    feed.clear();
    feed.addAll(
      await _questionsDb.loadFeed(
        sortBy: sortBy,
        startAfter: initialStartAfter(),
        sortDescending: sortBy != 'numAnswers',
        tags: null,
      ),
    );
  }

  void loadMoreQuestions() async {
    // TODO: this might not work if too many posts have the same number of votes
    final startAfter = sortBy == 'timestamp'
        ? feed.last.timestamp
        : sortBy == 'numVotes'
            ? feed.last.numVotes
            : feed.last.numAnswers;
    feed.addAll(
      await _questionsDb.loadFeed(
        sortBy: sortBy,
        startAfter: startAfter,
        sortDescending: sortBy != 'numAnswers',
        tags: null,
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
      feed.clear();
      feed.addAll(
        await _questionsDb.loadFeed(
          sortBy: sortBy,
          startAfter: initialStartAfter(),
          sortDescending: sortBy != 'numAnswers',
          tags: null,
        ),
      );
    }
  }
}

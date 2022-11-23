import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/models/user.dart';
import 'package:thinking_capp/services/auth.dart';
import 'package:thinking_capp/services/questions_db.dart';
import 'package:thinking_capp/services/users_db.dart';

class AppCache extends GetxService {
  final RxList<Question> feed = RxList.empty();
  DocumentSnapshot? feedLastDoc;
  bool feedReachedEnd = false;
  String feedSortBy = 'timestamp';
  final RxBool feedLoadingMore = false.obs;
  final RxList<AppUser> rankings = RxList.empty();

  Future<void> fetchData() async {
    await refreshFeed();
    rankings.addAll(await Get.find<UsersDbService>().getTopRanked(null));
  }

  Future<void> refreshFeed() async {
    feedLoadingMore.value = true;
    feed.clear();
    feedLastDoc = null;
    feedReachedEnd = false;
    await feedLoadMore();
    feedLoadingMore.value = false;
  }

  Future<void> feedLoadMore() async {
    if (feedReachedEnd) return;
    final page = await Get.find<QuestionsDbService>().loadFeed(
      sortBy: feedSortBy,
      startAfterDoc: feedLastDoc,
      sortDescending: feedSortBy != 'numAnswers',
      tags: Get.find<AuthService>().currentUser.followingTags,
    );
    feed.addAll(page.data);
    feedLastDoc = page.lastDoc;
    feedReachedEnd = page.reachedEnd;
  }

  void clearData() {
    feed.clear();
    rankings.clear();
  }
}

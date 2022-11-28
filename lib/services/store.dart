import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/models/user.dart';
import 'package:thinking_capp/services/auth.dart';
import 'package:thinking_capp/services/questions_db.dart';
import 'package:thinking_capp/services/users_db.dart';

class Store extends GetxService {
  final RxList<Question> feed = RxList.empty();
  DocumentSnapshot? feedLastDoc;
  bool feedReachedEnd = false;
  String feedSortBy = 'timestamp';
  final RxBool feedLoadingMore = false.obs;
  final RxList<MyUser> rankings = RxList.empty();

  // ensure this data remains synced throughout the app
  // the same questions/answers may be loaded as separate objects in different
  // pages, resulting in different myVote objects. The following ensures that
  // all question objects with the same id share the same myVote object.
  final Map<String, Rx<bool?>> myVotes = {}; // for both questions and answers

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

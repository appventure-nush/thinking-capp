import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/models/user.dart';
import 'package:thinking_capp/services/auth.dart';
import 'package:thinking_capp/services/questions_db.dart';
import 'package:thinking_capp/services/users_db.dart';

class AppCache extends GetxService {
  final RxList<Question> feed = RxList.empty();
  final RxList<AppUser> rankings = RxList.empty();

  Future<void> fetchData() async {
    feed.addAll(
      await Get.find<QuestionsDbService>().loadFeed(
        sortBy: 'timestamp',
        startAfter: Timestamp.now(),
        sortDescending: true,
        tags: Get.find<AuthService>().currentUser.followingTags,
      ),
    );
    rankings.addAll(await Get.find<UsersDbService>().getTopRanked(null));
  }

  void clearData() {
    feed.clear();
    rankings.clear();
  }
}

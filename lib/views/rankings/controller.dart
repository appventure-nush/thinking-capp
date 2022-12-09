import 'package:get/get.dart';
import 'package:thinking_capp/models/user.dart';
import 'package:thinking_capp/services/users_db.dart';

class RankingsController extends GetxController {
  final RxList<MyUser> rankings = RxList.empty();

  Future<void> refreshList() async {
    final newRankings = await Get.find<UsersDbService>().getTopRanked(null);
    rankings.clear();
    rankings.addAll(newRankings);
  }
}

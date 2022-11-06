import 'package:get/get.dart';
import 'package:thinking_capp/models/user.dart';
import 'package:thinking_capp/services/cache.dart';
import 'package:thinking_capp/services/users_db.dart';

class RankingsController extends GetxController {
  final _usersDb = Get.find<UsersDbService>();
  final _cache = Get.find<AppCache>();

  List<AppUser> get rankings => _cache.rankings;

  void loadMore() async {
    rankings.addAll(await _usersDb.getTopRanked(rankings.last.reputation));
    update();
  }
}

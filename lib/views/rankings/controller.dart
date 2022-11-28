import 'package:get/get.dart';
import 'package:thinking_capp/models/user.dart';
import 'package:thinking_capp/services/cache.dart';

class RankingsController extends GetxController {
  final _cache = Get.find<AppCache>();

  List<AppUser> get rankings => _cache.rankings;
}

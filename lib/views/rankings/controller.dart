import 'package:get/get.dart';
import 'package:thinking_capp/models/user.dart';
import 'package:thinking_capp/services/store.dart';

class RankingsController extends GetxController {
  final _store = Get.find<Store>();

  List<MyUser> get rankings => _store.rankings;
}

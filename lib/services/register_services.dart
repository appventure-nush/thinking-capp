import 'package:get/get.dart';
import 'package:thinking_capp/services/search.dart';

import 'cache.dart';
import 'auth.dart';
import 'media_picker.dart';
import 'questions_db.dart';
import 'storage.dart';
import 'users_db.dart';

void registerServices() {
  Get.put(AppCache());
  Get.put(MediaPickerService());
  Get.put(StorageService());
  Get.put(UsersDbService());
  Get.put(AuthService());
  Get.put(QuestionsDbService());
  Get.put(SearchService());
}

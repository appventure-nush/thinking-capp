import 'package:get/get.dart';

import 'answers_db.dart';
import 'auth.dart';
import 'media_picker.dart';
import 'questions_db.dart';
import 'storage.dart';
import 'users_db.dart';
import 'search.dart';
import 'voting.dart';

void registerServices() {
  Get.put(MediaPickerService());
  Get.put(StorageService());
  Get.put(VotingService());
  Get.put(UsersDbService());
  Get.put(AuthService());
  Get.put(QuestionsDbService());
  Get.put(AnswersDbService());
  Get.put(SearchService());
}

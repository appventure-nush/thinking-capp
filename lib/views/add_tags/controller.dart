import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/services/questions_db.dart';
import 'package:thinking_capp/services/storage.dart';
import 'package:thinking_capp/views/write_question/controller.dart';

const allTags = <String>[
  'Y1',
  'Y2',
  'Y3',
  'Y4',
  'Y5',
  'Y6',
  'Other',
  'Math',
  'Chemistry',
  'Physics',
  'Biology',
  'Computer Science',
];

class AddTagsController extends GetxController {
  final questionController = Get.find<WriteQuestionController>();
  final _questionsDb = Get.find<QuestionsDbService>();
  final _storage = Get.find<StorageService>();

  final textController = TextEditingController();

  final List<String> tags = [];
  final List<String> suggestions = List<String>.from(allTags);
  bool loading = false;

  @override
  void onReady() {
    textController.addListener(() {
      if (textController.text.isEmpty) {
        suggestions.clear();
        suggestions.addAll(allTags);
      } else {
        suggestions.clear();
        suggestions.addAll(allTags.where((tag) =>
            tag.toLowerCase().contains(textController.text.toLowerCase())));
      }
      update();
    });
  }

  void removeTag(String tag) {
    tags.remove(tag);
    update();
  }

  void addTag(String tag) {
    if (tags.contains(tag)) return;
    tags.add(tag);
    update();
  }

  void submit() async {
    // upload photos
    loading = true;
    update();
    final photoUrls = <String>[];
    for (final file in questionController.photos) {
      final url = await _storage.uploadPhoto(file, 'question');
      photoUrls.add(url);
    }
    await _questionsDb.postQuestion(
      questionController.titleController.text,
      questionController.descriptionController.text,
      photoUrls,
      tags,
    );
    loading = false;
    update();
    Get.back();
    Get.back();
  }
}

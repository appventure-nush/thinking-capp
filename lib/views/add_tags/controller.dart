import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/services/questions_db.dart';
import 'package:thinking_capp/services/storage.dart';
import 'package:thinking_capp/views/question/controller.dart';
import 'package:thinking_capp/views/write_question/controller.dart';

const allTags = <String>[
  'Y1',
  'Y2',
  'Y3',
  'Y4',
  'Y5',
  'Y6',
  'Core module',
  'Elective module',
  'Honours module',
  'Unrelated',
  'Beyond curriculum',
];

class AddTagsController extends GetxController {
  final questionController = Get.find<WriteQuestionController>();
  final _questionsDb = Get.find<QuestionsDbService>();
  final _storage = Get.find<StorageService>();

  final textController = TextEditingController();

  String? selectedSubject;
  final List<String> tags = [];
  final List<String> suggestions = List<String>.from(allTags);
  bool loading = false;

  final Question? _editQuestion;

  AddTagsController(this._editQuestion) {
    if (_editQuestion != null) {
      selectedSubject = _editQuestion!.tags[0];
      tags.addAll(_editQuestion!.tags.sublist(1));
    }
  }

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

  void selectSubject(String subject) {
    selectedSubject = subject;
    update();
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
    if (selectedSubject == null) {
      Get.rawSnackbar(
        message: 'You must choose a subject',
        backgroundColor: Palette.red,
      );
      return;
    }

    loading = true;
    update();
    // upload photos
    for (final photo in questionController.photos) {
      if (!photo.hasBeenUploaded) {
        photo.url = await _storage.uploadPhoto(photo.file, 'question');
      }
    }
    if (_editQuestion == null) {
      // new question
      await _questionsDb.postQuestion(
        questionController.titleController.text,
        questionController.descriptionController.text,
        questionController.photos.map((photo) => photo.url).toList(),
        [selectedSubject!] + tags,
      );
    } else {
      _editQuestion!.title.value = questionController.titleController.text;
      _editQuestion!.text.value = questionController.descriptionController.text;
      _editQuestion!.photoUrls.value =
          questionController.photos.map((photo) => photo.url).toList();
      _editQuestion!.tags.value = [selectedSubject!] + tags;
      await _questionsDb.editQuestion(
        _editQuestion!.id,
        _editQuestion!.title.value,
        _editQuestion!.text.value,
        _editQuestion!.photoUrls,
        _editQuestion!.tags,
      );
    }
    loading = false;
    update();
    Get.back();
    Get.back();
    if (_editQuestion != null) {
      // this doesnt update the other pages
      // change everything to rx attributes?
      Get.find<QuestionController>().update();
    }
    Get.rawSnackbar(
      message: _editQuestion == null
          ? 'Your question has been posted'
          : 'Question updated',
      backgroundColor: Palette.secondary,
    );
  }
}

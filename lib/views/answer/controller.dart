import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/services/media_picker.dart';
import 'package:thinking_capp/services/questions_db.dart';
import 'package:thinking_capp/services/storage.dart';
import 'package:thinking_capp/widgets/dialogs/yes_no_dialog.dart';

class AnswerController extends GetxController {
  final _mediaPicker = Get.find<MediaPickerService>();
  final _questionsDb = Get.find<QuestionsDbService>();
  final _storage = Get.find<StorageService>();

  final textController = TextEditingController();
  final List<File> photos = [];
  bool loading = false;

  final String _questionId;

  AnswerController(this._questionId);

  void addPhoto(bool fromGallery) async {
    final file = fromGallery
        ? await _mediaPicker.selectFromGallery()
        : await _mediaPicker.takePhotoWithCamera();
    if (file != null) {
      photos.add(file);
      update();
    }
  }

  void askRemovePhoto(int i) async {
    final confirm = await Get.dialog(
        YesNoDialog(title: 'Confirmation', text: 'Remove this photo?'));
    if (confirm ?? false) {
      photos.removeAt(i);
      update();
    }
  }

  void submit() async {
    if (textController.text.isEmpty) {
      Get.rawSnackbar(
        shouldIconPulse: false,
        message: 'You need to write something',
        backgroundColor: Palette.red,
      );
      return;
    }
    loading = true;
    update();
    final photoUrls = <String>[];
    for (final file in photos) {
      final url = await _storage.uploadPhoto(file, 'answer');
      photoUrls.add(url);
    }
    await _questionsDb.postAnswer(_questionId, textController.text, photoUrls);
    loading = false;
    update();
    Get.back();
  }
}

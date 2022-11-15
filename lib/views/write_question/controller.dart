import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/services/media_picker.dart';
import 'package:thinking_capp/views/add_tags/add_tags.dart';
import 'package:thinking_capp/widgets/dialogs/yes_no_dialog.dart';

class WriteQuestionController extends GetxController {
  final _mediaPicker = Get.find<MediaPickerService>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final List<File> photos = [];

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

  void submit() {
    if (titleController.text.isEmpty) {
      Get.rawSnackbar(
        shouldIconPulse: false,
        message: 'A title is required',
        backgroundColor: Palette.red,
      );
      return;
    }
    if (descriptionController.text.isEmpty && photos.isEmpty) {
      Get.rawSnackbar(
        shouldIconPulse: false,
        message: 'A description or photo is required',
        backgroundColor: Palette.red,
      );
      return;
    }
    Get.to(() => AddTagsView());
  }
}

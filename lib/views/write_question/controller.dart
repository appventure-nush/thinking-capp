import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/services/media_picker.dart';
import 'package:thinking_capp/views/add_tags/add_tags.dart';
import 'package:thinking_capp/views/write_question/photo.dart';
import 'package:thinking_capp/widgets/dialogs/yes_no_dialog.dart';

class WriteQuestionController extends GetxController {
  final _mediaPicker = Get.find<MediaPickerService>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final List<Photo> photos = [];

  final Question? _editQuestion;

  WriteQuestionController(this._editQuestion) {
    if (_editQuestion != null) {
      titleController.text = _editQuestion!.title.value;
      descriptionController.text = _editQuestion!.text.value;
      photos.addAll(_editQuestion!.photoUrls.map((url) => Photo.url(url)));
    }
  }

  void addPhoto(bool fromGallery) async {
    final file = fromGallery
        ? await _mediaPicker.selectFromGallery()
        : await _mediaPicker.takePhotoWithCamera();
    if (file != null) {
      photos.add(Photo.file(file));
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
        message: 'A title is required',
        backgroundColor: Palette.red,
      );
      return;
    }
    if (descriptionController.text.isEmpty && photos.isEmpty) {
      Get.rawSnackbar(
        message: 'A description or photo is required',
        backgroundColor: Palette.red,
      );
      return;
    }
    Get.to(() => AddTagsView(editQuestion: _editQuestion));
  }
}

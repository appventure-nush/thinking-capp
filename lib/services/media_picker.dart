import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MediaPickerService extends GetxService {
  Future<File?> selectFromGallery() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    return file == null ? null : File(file.path);
  }

  Future<File?> takePhotoWithCamera() async {
    final file = await ImagePicker().pickImage(source: ImageSource.camera);
    return file == null ? null : File(file.path);
  }
}

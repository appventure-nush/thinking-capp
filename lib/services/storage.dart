import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import 'auth.dart';

class StorageService extends GetxService {
  final _storageRef = FirebaseStorage.instance.ref();

  Future<String> uploadPhoto(File file, String prefix) async {
    final tempDir = await getTemporaryDirectory();
    final uid = Get.find<AuthService>().currentUser.id;
    final id = _randomString();
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.path,
      '${tempDir.path}/$id.jpg',
      quality: 70,
    );
    final storagePath = 'photos/$uid/${prefix}_$id.jpg';
    final taskSnapshot =
        await _storageRef.child(storagePath).putFile(compressedFile!);
    return taskSnapshot.ref.getDownloadURL();
  }

  String _randomString() {
    var random = Random();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(10, (i) => chars[random.nextInt(chars.length)]).join();
  }

  Future<void> deletePhoto(String photoUrl) =>
      FirebaseStorage.instance.refFromURL(photoUrl).delete();
}

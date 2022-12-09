import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/services/auth.dart';
import 'package:thinking_capp/services/media_picker.dart';
import 'package:thinking_capp/services/storage.dart';
import 'package:thinking_capp/services/users_db.dart';
import 'package:thinking_capp/views/examine_photo.dart';
import 'package:thinking_capp/views/history/history.dart';
import 'package:thinking_capp/views/profile/profile.dart';
import 'package:thinking_capp/views/settings/settings.dart';
import 'package:thinking_capp/widgets/default_feedback.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({Key? key}) : super(key: key);

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  final user = Get.find<AuthService>().currentUser;

  void _viewPhoto() {
    if (user.photoUrl == '') {
      _changePhoto();
    } else {
      Get.to(
        () => ExaminePhotoView(
          photoUrl: user.photoUrl,
          heroTag: 'profilephoto',
        ),
        transition: Transition.fadeIn,
      );
    }
  }

  void _changePhoto() async {
    final file = await Get.find<MediaPickerService>().selectFromGallery();
    if (file != null) {
      final photoUrl =
          await Get.find<StorageService>().uploadPhoto(file, 'profile');
      user.photoUrl = photoUrl;
      await Get.find<UsersDbService>().updateUser({'photoUrl': photoUrl});
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              'Profile',
              style: TextStyle(
                color: Palette.primary,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 60),
            GestureDetector(
              onTap: _viewPhoto,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(color: Palette.primary, width: 4),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: user.photoUrl == ''
                    ? Center(
                        child: Icon(
                          Icons.person_outlined,
                          size: 48,
                          color: Palette.primary,
                        ),
                      )
                    : Hero(
                        tag: 'profilephoto',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60 - 4),
                          child: CachedNetworkImage(
                            imageUrl: user.photoUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -25),
              child: GestureDetector(
                onTap: _changePhoto,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Palette.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.cached,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 7),
            Text(
              user.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12),
            Text(
              '${user.reputation} reputation',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 50),
            _buildButton('Your posts', () {
              Get.to(ProfileView(user: user));
            }),
            SizedBox(height: 12),
            _buildButton('History', () {
              Get.to(HistoryView());
            }),
            SizedBox(height: 12),
            _buildButton('Settings', () {
              Get.to(SettingsView());
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, Function() onPressed) {
    return DefaultFeedback(
      onPressed: onPressed,
      child: Container(
        width: 160,
        height: 50,
        decoration: BoxDecoration(
          color: Palette.black2,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

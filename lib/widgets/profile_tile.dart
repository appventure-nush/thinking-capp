import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/models/user.dart';
import 'package:thinking_capp/widgets/pressed_builder.dart';

class ProfileTile extends StatelessWidget {
  final AppUser user;

  const ProfileTile({Key? key, required this.user}) : super(key: key);

  void _onPressed() {
    // Get.to(ProfileView(user: user));
  }

  @override
  Widget build(BuildContext context) {
    return PressedBuilder(
      onPressed: _onPressed,
      builder: (pressed) => AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Palette.black1.withOpacity(pressed ? 1 : 0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xffa4a4a4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Icon(
                  Icons.person_outlined,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text(
                  '${user.reputation} reputation',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

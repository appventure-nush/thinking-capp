import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/services/auth.dart';
import 'package:thinking_capp/views/about.dart';
import 'package:thinking_capp/views/welcome.dart';
import 'package:thinking_capp/widgets/app_bar.dart';
import 'package:thinking_capp/widgets/default_feedback.dart';
import 'package:thinking_capp/widgets/dialogs/yes_no_dialog.dart';
import 'package:thinking_capp/widgets/switch.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  void _signOut() async {
    final confirm = await Get.dialog(YesNoDialog(
      title: 'Confirmation',
      text: 'Are you sure you want to sign out?',
    ));
    if (confirm ?? false) {
      await Get.find<AuthService>().signOut();
      Get.offAll(WelcomeView());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Settings'),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 12, bottom: 16),
              child: Text(
                'Notifications',
                style: TextStyle(
                  color: Palette.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Palette.black1,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildSwitchSetting(
                    'Enable notifications',
                    true,
                    (p0) => null,
                    pv: 18,
                  ),
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  SizedBox(height: 6),
                  _buildSwitchSetting('New questions', true, (p0) => null),
                  _buildSwitchSetting(
                      'Answers to your questions', true, (p0) => null),
                  _buildSwitchSetting('Question upvotes', true, (p0) => null),
                  _buildSwitchSetting(
                      'Comments on your answers', true, (p0) => null),
                  _buildSwitchSetting('Answer upvotes', true, (p0) => null),
                  SizedBox(height: 6),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 32, bottom: 16),
              child: Text(
                'Other actions',
                style: TextStyle(
                  color: Palette.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            DefaultFeedback(
              onPressed: _signOut,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Palette.black1,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Sign out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
            DefaultFeedback(
              onPressed: () {
                Get.to(AboutView());
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Palette.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'About this app',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchSetting(
    String label,
    bool value,
    Function(bool) onChanged, {
    double pv = 12,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: pv),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          MySwitch(defaultValue: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/services/auth.dart';
import 'package:thinking_capp/services/store.dart';
import 'package:thinking_capp/services/users_db.dart';
import 'package:thinking_capp/views/home/home.dart';
import 'package:thinking_capp/widgets/app_bar.dart';
import 'package:thinking_capp/widgets/default_feedback.dart';
import 'package:thinking_capp/widgets/floating_action_button.dart';
import 'package:thinking_capp/widgets/switch.dart';

import 'subjects.dart';

class SelectSubjectsView extends StatefulWidget {
  final bool isOnboarding; // false when first creating account

  const SelectSubjectsView({
    Key? key,
    required this.isOnboarding,
  }) : super(key: key);

  @override
  State<SelectSubjectsView> createState() => _SelectSubjectsViewState();
}

class _SelectSubjectsViewState extends State<SelectSubjectsView> {
  final _user = Get.find<AuthService>().currentUser;

  final searchController = TextEditingController();

  List<String> visibleSubjects = subjects;
  final List<String> selected = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    selected.addAll(_user.followingTags);
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        setState(() => visibleSubjects = subjects);
      } else {
        setState(() {
          visibleSubjects = subjects
              .where((m) =>
                  m.toLowerCase().contains(searchController.text.toLowerCase()))
              .toList();
        });
      }
    });
  }

  void _setShowEverything(bool value) async {
    _user.showEverything = value;
    await Get.find<UsersDbService>()
        .updateUser(_user.id, {'showEverything': value});
  }

  void _onSubmit() async {
    if (selected.isEmpty) {
      Get.rawSnackbar(
        message: 'You must choose at least one subject',
        backgroundColor: Palette.red,
      );
      return;
    }

    setState(() => loading = true);
    _user.followingTags = selected;
    await Get.find<UsersDbService>().updateUser(
      _user.id,
      {'followingTags': selected},
    );
    setState(() => loading = false);
    if (widget.isOnboarding) {
      // load feed only after setting up account
      await Get.find<Store>().fetchData();
      Get.offAll(() => HomeView());
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          widget.isOnboarding ? null : MyAppBar(title: 'Customize your feed'),
      floatingActionButton: MyFloatingActionButton(
        icon: Icons.check,
        loading: loading,
        onPressed: _onSubmit,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // show title text instead of appbar
            if (widget.isOnboarding)
              SizedBox(height: 36 + Get.mediaQuery.padding.top),
            if (widget.isOnboarding)
              Center(
                child: Text(
                  'Select your subjects',
                  style: TextStyle(
                    color: Palette.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            SizedBox(height: widget.isOnboarding ? 36 : 20),
            if (!widget.isOnboarding)
              Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 24),
                margin: EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Palette.black1,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Show everything',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    MySwitch(
                      defaultValue: _user.showEverything,
                      onChanged: _setShowEverything,
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Stack(
                children: [
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 2,
                    ),
                    padding: EdgeInsets.zero,
                    itemCount: visibleSubjects.length,
                    itemBuilder: (context, i) {
                      return _buildSubjectTile(visibleSubjects[i]);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectTile(String subject) {
    final isSelected = selected.contains(subject);
    return DefaultFeedback(
      onPressed: () {
        setState(() {
          if (selected.contains(subject)) {
            selected.remove(subject);
          } else {
            selected.add(subject);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Palette.primary : Palette.black1,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            subject,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

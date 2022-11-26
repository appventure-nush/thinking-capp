import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/services/auth.dart';
import 'package:thinking_capp/services/users_db.dart';
import 'package:thinking_capp/views/home/home.dart';
import 'package:thinking_capp/widgets/app_bar.dart';
import 'package:thinking_capp/widgets/default_feedback.dart';
import 'package:thinking_capp/widgets/floating_action_button.dart';

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
  final _currentUser = Get.find<AuthService>().currentUser;

  final searchController = TextEditingController();

  List<String> visibleSubjects = subjects;
  final List<String> selected = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    selected.addAll(_currentUser.followingTags);
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

  void _onSubmit() async {
    if (selected.isEmpty) {
      Get.rawSnackbar(
        message: 'You must choose at least one subject',
        backgroundColor: Palette.red,
      );
      return;
    }

    setState(() => loading = true);
    _currentUser.followingTags = selected;
    await Get.find<UsersDbService>().updateUser(
      _currentUser.id,
      {'followingTags': selected},
    );
    setState(() => loading = false);
    if (widget.isOnboarding) {
      Get.off(() => HomeView());
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          widget.isOnboarding ? null : MyAppBar(title: 'Edit your subjects'),
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
            // _buildSearchField(),
            // SizedBox(height: widget.isOnboarding ? 36 : 20),
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
                  // Container(
                  //   height: 16,
                  //   decoration: BoxDecoration(
                  //     gradient: LinearGradient(
                  //       begin: Alignment.topCenter,
                  //       end: Alignment.bottomCenter,
                  //       colors: [
                  //         Palette.black,
                  //         Palette.black.withOpacity(0),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Palette.black1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          SizedBox(width: 24),
          Icon(
            Icons.search,
            size: 20,
          ),
          SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: searchController,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              ),
              cursorColor: Colors.white,
            ),
          ),
        ],
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/utils/animation.dart';
import 'package:thinking_capp/views/search/browse_subjects.dart';
import 'package:thinking_capp/views/search/controller.dart';
import 'package:thinking_capp/views/search/results.dart';
import 'package:thinking_capp/widgets/pressed_builder.dart';

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchController>(
      init: SearchController(),
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: AnimatedPadding(
              duration: shortAnimationDuration,
              padding: EdgeInsets.all(controller.focusNode.hasFocus ? 12 : 20),
              child: Column(
                children: [
                  _buildSearchField(controller),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: mediumAnimationDuration,
                      child: controller.focusNode.hasFocus
                          ? SearchResults()
                          : BrowseSubjects(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchField(SearchController controller) {
    return AnimatedContainer(
      duration: shortAnimationDuration,
      height: controller.focusNode.hasFocus ? 76 : 60,
      decoration: BoxDecoration(
        color: controller.focusNode.hasFocus ? Palette.black2 : Palette.black1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          SizedBox(width: 18),
          PressedBuilder(
            onPressed: Get.back,
            builder: (pressed) => AnimatedContainer(
              duration: shortAnimationDuration,
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(pressed ? 0.1 : 0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              focusNode: controller.focusNode,
              controller: controller.textController,
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
}

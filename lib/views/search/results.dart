import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/models/answer.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/utils/animation.dart';
import 'package:thinking_capp/views/feed/question_card.dart';
import 'package:thinking_capp/views/question/answer_card.dart';
import 'package:thinking_capp/views/question/question.dart';
import 'package:thinking_capp/views/search/controller.dart';
import 'package:thinking_capp/widgets/pressed_builder.dart';
import 'package:thinking_capp/widgets/profile_tile.dart';

class SearchResults extends StatelessWidget {
  SearchController get controller => Get.find();

  const SearchResults({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Row(
          children: [
            SizedBox(width: 8),
            _buildCategoryTile(
              'Questions',
              controller.selectedCategory == 'Questions',
              () => controller.selectCategory('Questions'),
            ),
            SizedBox(width: 14),
            _buildCategoryTile(
              'Answers',
              controller.selectedCategory == 'Answers',
              () => controller.selectCategory('Answers'),
            ),
            SizedBox(width: 14),
            _buildCategoryTile(
              'Users',
              controller.selectedCategory == 'Users',
              () => controller.selectCategory('Users'),
            ),
            SizedBox(width: 8),
          ],
        ),
        SizedBox(height: 20),
        Expanded(
          child: AnimatedSwitcher(
            duration: mediumAnimationDuration,
            child: controller.loading
                ? Center(child: CircularProgressIndicator())
                : controller.textController.text.isNotEmpty &&
                        controller.results.isEmpty
                    ? _buildPlaceholder()
                    : controller.results.isEmpty
                        ? SizedBox()
                        : _buildList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTile(
    String category,
    bool isSelected,
    Function() onPressed,
  ) {
    return PressedBuilder(
      onPressed: () {
        if (!isSelected) onPressed();
      },
      builder: (pressed) => AnimatedContainer(
        duration: shortAnimationDuration,
        height: 44,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Palette.primary : Palette.black1,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              color: isSelected
                  ? Colors.black
                  : Colors.white.withOpacity(pressed ? 0.6 : 1),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/search_empty.png',
          height: 160,
        ),
        SizedBox(height: 28),
        Text(
          'We couldnt find anything...',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildList() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListView.builder(
        itemCount: controller.results.length,
        itemBuilder: (context, i) {
          final obj = controller.results[i];
          if (obj is Question) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: QuestionCard(
                question: obj,
                onPressed: () {
                  Get.to(() => QuestionView(question: obj));
                },
              ),
            );
          } else if (obj is Answer) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AnswerCard(
                answer: obj,
                onPressed: () {},
              ),
            );
          } else {
            return ProfileTile(user: obj);
          }
        },
      ),
    );
  }
}

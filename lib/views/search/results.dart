import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/utils/animation.dart';
import 'package:thinking_capp/views/feed/question_card.dart';
import 'package:thinking_capp/views/question/question.dart';
import 'package:thinking_capp/views/search/controller.dart';
import 'package:thinking_capp/widgets/pressed_builder.dart';

class SearchResults extends StatelessWidget {
  SearchController get controller => Get.find();

  const SearchResults({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          SizedBox(height: 16),
          Row(
            children: [
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
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: controller.questionResults.length,
              itemBuilder: (context, i) {
                final question = controller.questionResults[i];
                return QuestionCard(
                  question: question,
                  onPressed: () {
                    Get.to(() => QuestionView(question: question));
                  },
                );
              },
            ),
          ),
        ],
      ),
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
}

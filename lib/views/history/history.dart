import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/utils/animation.dart';
import 'package:thinking_capp/views/feed/question_card.dart';
import 'package:thinking_capp/views/history/controller.dart';
import 'package:thinking_capp/views/question/question.dart';
import 'package:thinking_capp/widgets/app_bar.dart';
import 'package:thinking_capp/widgets/loading.dart';
import 'package:thinking_capp/widgets/tab_bar.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryController>(
      init: HistoryController(),
      builder: (controller) {
        return Scaffold(
          appBar: MyAppBar(title: 'History'),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(height: 24),
                MyTabBar(
                  tabs: const ['Upvoted', 'Downvoted', 'Bookmarked'],
                  onChanged: controller.changeTab,
                ),
                SizedBox(height: 36),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: mediumAnimationDuration,
                    child: controller.loading
                        ? Center(child: Loading())
                        : _buildQuestionsList(controller),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuestionsList(HistoryController controller) {
    return Container(
      key: ValueKey(controller.tab),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListView.builder(
        itemCount: controller.questions.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: QuestionCard(
              question: controller.questions[i],
              onPressed: () {
                Get.to(QuestionView(question: controller.questions[i]));
              },
            ),
          );
        },
      ),
    );
  }
}

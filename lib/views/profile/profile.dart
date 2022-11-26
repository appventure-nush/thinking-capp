import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/models/user.dart';
import 'package:thinking_capp/utils/animation.dart';
import 'package:thinking_capp/views/feed/question_card.dart';
import 'package:thinking_capp/views/profile/controller.dart';
import 'package:thinking_capp/views/question/answer_card.dart';
import 'package:thinking_capp/views/question/question.dart';
import 'package:thinking_capp/widgets/app_bar.dart';
import 'package:thinking_capp/widgets/loading.dart';
import 'package:thinking_capp/widgets/tab_bar.dart';

class ProfileView extends StatelessWidget {
  final AppUser user;

  const ProfileView({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(user.id),
      builder: (controller) {
        return Scaffold(
          appBar: MyAppBar(title: "Answers posted by ${user.name}"),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 36),
                // MyTabBar(
                //   tabs: const ['Questions', 'Answers'],
                //   onChanged: controller.changeTab,
                // ),
                // SizedBox(height: 20),
                SizedBox(height: 20),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: mediumAnimationDuration,
                    child: controller.loading
                        ? Center(child: Loading())
                        : _buildAnswersList(controller),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget _buildQuestionsList(ProfileController controller) {
  //   return Container(
  //     key: ValueKey('questions'),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(20),
  //         topRight: Radius.circular(20),
  //       ),
  //     ),
  //     clipBehavior: Clip.antiAlias,
  //     child: ListView.builder(
  //       itemCount: controller.questions.length,
  //       itemBuilder: (context, i) {
  //         return Padding(
  //           padding: const EdgeInsets.only(bottom: 12),
  //           child: QuestionCard(
  //             question: controller.questions[i],
  //             onPressed: () {
  //               Get.to(QuestionView(question: controller.questions[i]));
  //             },
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _buildAnswersList(ProfileController controller) {
    return Container(
      key: ValueKey('answers'),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListView.builder(
        itemCount: controller.answers.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AnswerCard(
              answer: controller.answers[i],
              onPressed: () {
                // Get.to(QuestionView());
              },
            ),
          );
        },
      ),
    );
  }
}

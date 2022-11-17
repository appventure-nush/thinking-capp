import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/models/user.dart';
import 'package:thinking_capp/services/auth.dart';
import 'package:thinking_capp/views/feed/controller.dart';
import 'package:thinking_capp/views/feed/question_card.dart';
import 'package:thinking_capp/views/question/question.dart';
import 'package:thinking_capp/views/search/search.dart';
import 'package:thinking_capp/views/select_subjects/select_subjects.dart';
import 'package:thinking_capp/widgets/default_feedback.dart';

class FeedView extends StatelessWidget {
  const FeedView({Key? key}) : super(key: key);

  AppUser get currentUser => Get.find<AuthService>().currentUser;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedController>(
      init: FeedController(),
      builder: (controller) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 16),
                    DefaultFeedback(
                      onPressed: () {
                        Get.to(SelectSubjectsView(isOnboarding: false))
                            // update number of subjects displayed
                            ?.then((_) => controller.update());
                      },
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 28),
                        decoration: BoxDecoration(
                          color: Palette.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            '${currentUser.followingTags.length} Subjects',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    _buildIconButton(Icons.sort, controller.selectSortBy),
                    SizedBox(width: 12),
                    _buildIconButton(Icons.search, () {
                      Get.to(SearchView());
                    }),
                    SizedBox(width: 16),
                  ],
                ),
                SizedBox(height: 24),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Obx(
                      () => RefreshIndicator(
                        onRefresh: controller.refreshFeed,
                        child: ListView.builder(
                          controller: controller.scrollController,
                          padding: const EdgeInsets.only(bottom: 100),
                          itemCount: controller.feed.length,
                          itemBuilder: (context, index) {
                            final question = controller.feed[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: QuestionCard(
                                question: question,
                                onPressed: () {
                                  Get.to(
                                      () => QuestionView(question: question));
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconButton(IconData icon, Function() onPressed) {
    return DefaultFeedback(
      onPressed: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Palette.black2,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Icon(icon),
        ),
      ),
    );
  }
}

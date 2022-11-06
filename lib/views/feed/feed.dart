import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/views/feed/controller.dart';
import 'package:thinking_capp/views/feed/question_card.dart';
import 'package:thinking_capp/widgets/default_feedback.dart';

class FeedView extends StatelessWidget {
  const FeedView({Key? key}) : super(key: key);

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
                      SizedBox(width: 20),
                      Text(
                        'Feed',
                        style: TextStyle(
                          color: Palette.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Spacer(),
                      _buildIconButton(Icons.filter_list, () {}),
                      SizedBox(width: 12),
                      _buildIconButton(Icons.search, () {}),
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
                        () => NotificationListener<
                            OverscrollIndicatorNotification>(
                          onNotification: (overscroll) {
                            if (!overscroll.leading) {
                              overscroll.disallowIndicator();
                            }
                            return true;
                          },
                          child: RefreshIndicator(
                            onRefresh: controller.refreshFeed,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 100),
                              itemCount: controller.feed.length,
                              itemBuilder: (context, index) {
                                final question = controller.feed[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: QuestionCard(
                                    question: question,
                                    onPressed: () =>
                                        controller.toQuestion(question),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _buildIconButton(IconData icon, Function() onPressed) {
    return DefaultFeedback(
      onPressed: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Palette.black1,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Icon(icon),
        ),
      ),
    );
  }
}

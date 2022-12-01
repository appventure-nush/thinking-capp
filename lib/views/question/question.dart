import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/utils/datetime.dart';
import 'package:thinking_capp/views/question/controller.dart';
import 'package:thinking_capp/views/tag/tag.dart';
import 'package:thinking_capp/widgets/photo_carousel.dart';
import 'package:thinking_capp/views/question/answer_card.dart';
import 'package:thinking_capp/widgets/app_bar.dart';
import 'package:thinking_capp/widgets/default_feedback.dart';
import 'package:thinking_capp/widgets/loading.dart';
import 'package:thinking_capp/widgets/question_tag.dart';
import 'package:thinking_capp/widgets/tab_bar.dart';
import 'package:thinking_capp/widgets/voting_box.dart';

class QuestionView extends StatelessWidget {
  final Question question;

  const QuestionView({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionController>(
      init: QuestionController(question),
      builder: (controller) {
        return Scaffold(
          appBar: MyAppBar(
            title: 'Question',
            suffixIcons: {
              if (question.byMe) Icons.edit_outlined: controller.toEditQuestion,
              (controller.isBookmarked
                  ? Icons.bookmark
                  : Icons.bookmark_outline): controller.toggleBookmarkQuestion,
            },
          ),
          body: SingleChildScrollView(
            controller: controller.scrollController,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 36),
                      Text(
                        question.title,
                        style: TextStyle(
                          color: Palette.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (question.text.isNotEmpty) SizedBox(height: 14),
                      if (question.text.isNotEmpty)
                        Text(
                          question.text,
                          style: TextStyle(fontSize: 12),
                        ),
                      if (question.photoUrls.isNotEmpty) SizedBox(height: 20),
                      if (question.photoUrls.isNotEmpty)
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: PhotoCarousel(photoUrls: question.photoUrls),
                        ),
                      SizedBox(height: 20),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: question.tags
                            .map((tag) => QuestionTag(
                                  label: tag,
                                  onPressed: () {
                                    Get.to(TagView(tag: tag));
                                  },
                                ))
                            .toList(),
                      ),
                      SizedBox(height: 28),
                      Row(
                        children: [
                          VotingBox(
                            myVote: question.myVote,
                            questionId: question.id,
                          ),
                          Spacer(),
                          Text(
                            formatTimeAgo(question.timestamp),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Row(
                        children: [
                          Text(
                            '${question.numAnswers} answers',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          MyTabBar(
                            tabs: const ['Top', 'Newest'],
                            onChanged: controller.switchTab,
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      DefaultFeedback(
                        onPressed: controller.toWriteAnswer,
                        child: Container(
                          height: 60,
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            color: Palette.black1,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 20,
                                color: Colors.white.withOpacity(0.6),
                              ),
                              SizedBox(width: 16),
                              Text(
                                'Write your answer',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      if (controller.loadingAnswers)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 32),
                            child: Loading(),
                          ),
                        )
                      else if (controller.answers.isEmpty)
                        Column(
                          children: [
                            SizedBox(height: 60),
                            Image.asset('assets/images/empty.png', width: 280),
                            SizedBox(height: 28),
                            Text(
                              'Nothing here yet',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 60),
                          ],
                        )
                      else
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.answers.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AnswerCard(
                                answer: controller.answers[i],
                                onPressed: () {},
                              ),
                            );
                          },
                        ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

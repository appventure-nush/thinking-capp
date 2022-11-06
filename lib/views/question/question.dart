import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/utils/datetime.dart';
import 'package:thinking_capp/views/answer/answer.dart';
import 'package:thinking_capp/views/feed/photo_carousel.dart';
import 'package:thinking_capp/widgets/app_bar.dart';
import 'package:thinking_capp/widgets/default_feedback.dart';
import 'package:thinking_capp/widgets/profile_tile.dart';
import 'package:thinking_capp/widgets/question_tag.dart';
import 'package:thinking_capp/widgets/tab_bar.dart';
import 'package:thinking_capp/widgets/votes.dart';

class QuestionView extends StatelessWidget {
  final Question question;

  const QuestionView({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Question', actions: {}),
      body: SingleChildScrollView(
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
                        .map((tag) => QuestionTag(label: tag, onPressed: () {}))
                        .toList(),
                  ),
                  SizedBox(height: 16),
                  FractionallySizedBox(
                    widthFactor: 1 + 20 / (Get.width - 72),
                    child: ProfileTile(user: question.poster),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Votes(upvotes: question.upvotes, vote: question.myVote),
                      Spacer(),
                      Text(formatTimeAgo(question.timestamp)),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Text(
                        '0 answers',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      MyTabBar(
                        tabs: const ['Top', 'Newest'],
                        onChanged: (tab) {
                          // TODO
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  DefaultFeedback(
                    onPressed: () {
                      Get.to(AnswerView(questionId: question.id));
                    },
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
                  SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

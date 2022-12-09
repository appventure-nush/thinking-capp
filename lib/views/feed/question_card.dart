import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/utils/datetime.dart';
import 'package:thinking_capp/views/tag/tag.dart';
import 'package:thinking_capp/widgets/photo_carousel.dart';
import 'package:thinking_capp/widgets/default_feedback.dart';
import 'package:thinking_capp/widgets/question_tag.dart';
import 'package:thinking_capp/widgets/voting_box.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final Function() onPressed;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultFeedback(
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Palette.black1,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                question.title,
                style: TextStyle(
                  color: Palette.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (question.photoUrls.isNotEmpty) SizedBox(height: 20),
            if (question.photoUrls.isNotEmpty)
              // images
              PhotoCarousel(photoUrls: question.photoUrls),
            if (question.tags.isNotEmpty) SizedBox(height: 16),
            if (question.tags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: question.tags
                    .map((tag) => QuestionTag(
                          label: tag,
                          onPressed: () {
                            Get.to(TagView(tag: tag));
                          },
                        ))
                    .toList(),
              ),
            SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                VotingBox(
                  myVote: question.myVote,
                  questionId: question.id,
                ),
                SizedBox(width: 12),
                if (question.numAnswers > 0)
                  Container(
                    height: 36,
                    padding: EdgeInsets.only(left: 14, right: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 16,
                        ),
                        SizedBox(width: 12),
                        Text(
                          '${question.numAnswers}',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                Spacer(),
                Text(
                  formatTimeAgo(question.timestamp),
                  style: TextStyle(color: Colors.white.withOpacity(0.6)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

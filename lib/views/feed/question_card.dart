import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/services/questions_db.dart';
import 'package:thinking_capp/utils/datetime.dart';
import 'package:thinking_capp/views/tag/tag.dart';
import 'package:thinking_capp/widgets/photo_carousel.dart';
import 'package:thinking_capp/widgets/default_feedback.dart';
import 'package:thinking_capp/widgets/question_tag.dart';
import 'package:thinking_capp/widgets/voting_box.dart';

class QuestionCard extends StatelessWidget {
  final _questionsDb = Get.find<QuestionsDbService>();

  final Question question;
  final Function() onPressed;

  QuestionCard({
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
                  numVotes: _questionsDb.numVotesStream(question.id),
                  myVote: question.myVote,
                  questionId: question.id,
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

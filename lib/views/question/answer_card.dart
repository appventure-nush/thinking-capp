import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/models/answer.dart';
import 'package:thinking_capp/services/questions_db.dart';
import 'package:thinking_capp/utils/datetime.dart';
import 'package:thinking_capp/widgets/photo_carousel.dart';
import 'package:thinking_capp/widgets/default_feedback.dart';
import 'package:thinking_capp/widgets/voting_box.dart';

class AnswerCard extends StatelessWidget {
  final _questionsDb = Get.find<QuestionsDbService>();

  final Answer answer;
  final Function() onPressed;

  AnswerCard({
    Key? key,
    required this.answer,
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
            Text(
              answer.text,
              style: TextStyle(fontSize: 12),
            ),
            if (answer.photoUrls.isNotEmpty) SizedBox(height: 20),
            if (answer.photoUrls.isNotEmpty)
              PhotoCarousel(photoUrls: answer.photoUrls),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                VotingBox(
                  numVotes: _questionsDb.numVotesStream(
                    answer.questionId,
                    answerId: answer.id,
                  ),
                  myVote: answer.myVote,
                  questionId: answer.questionId,
                  answerId: answer.id,
                ),
                Spacer(),
                Text(
                  formatTimeAgo(answer.timestamp),
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

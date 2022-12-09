import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/models/answer.dart';
import 'package:thinking_capp/utils/datetime.dart';
import 'package:thinking_capp/widgets/photo_carousel.dart';
import 'package:thinking_capp/widgets/default_feedback.dart';
import 'package:thinking_capp/widgets/profile_tile.dart';
import 'package:thinking_capp/widgets/voting_box.dart';

class AnswerCard extends StatelessWidget {
  final Answer answer;
  final Function() onPressed;

  const AnswerCard({
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
              style: TextStyle(fontSize: 14),
            ),
            if (answer.photoUrls.isNotEmpty) SizedBox(height: 20),
            if (answer.photoUrls.isNotEmpty)
              PhotoCarousel(photoUrls: answer.photoUrls),
            SizedBox(height: 18),
            FractionallySizedBox(
              widthFactor: 1 + 20 / (Get.width - 64),
              child: ProfileTile(user: answer.poster),
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                VotingBox(
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

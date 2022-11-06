import 'package:flutter/material.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/utils/datetime.dart';
import 'package:thinking_capp/views/feed/photo_carousel.dart';
import 'package:thinking_capp/widgets/default_feedback.dart';
import 'package:thinking_capp/widgets/votes.dart';

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
            // images
            if (question.photoUrls.isNotEmpty)
              PhotoCarousel(photoUrls: question.photoUrls),
            SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Votes(upvotes: question.upvotes, vote: null),
                Spacer(),
                Text(formatTimeAgo(question.timestamp)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

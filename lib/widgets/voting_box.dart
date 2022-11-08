import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/services/questions_db.dart';

class VotingBox extends StatelessWidget {
  final _questionsDb = Get.find<QuestionsDbService>();

  final Stream<int> numVotes;
  final Rx<bool?> myVote;
  final String questionId;
  final String? answerId;

  VotingBox({
    Key? key,
    required this.numVotes,
    required this.myVote,
    required this.questionId,
    this.answerId,
  }) : super(key: key);

  void _changeVote(bool? newVote) async {
    if (newVote == null) {
      await _questionsDb.removeVote(
        questionId,
        answerId: answerId,
        oldVote: myVote.value!,
      );
    } else if (newVote == true) {
      await _questionsDb.upvote(
        questionId,
        answerId: answerId,
        removeDownvote: myVote.value == false,
      );
    } else {
      await _questionsDb.downvote(
        questionId,
        answerId: answerId,
        removeUpvote: myVote.value == true,
      );
    }
    myVote.value = newVote;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Obx(
        () => Row(
          children: [
            GestureDetector(
              onTap: () {
                _changeVote(myVote.value == true ? null : true);
              },
              child: Icon(
                Icons.arrow_upward,
                size: 20,
                color: myVote.value == true ? Palette.primary : Colors.white,
              ),
            ),
            SizedBox(width: 8),
            SizedBox(
              width: 20,
              child: Center(
                child: StreamBuilder<int>(
                  stream: numVotes,
                  builder: (context, snapshot) {
                    return Text(
                      '${snapshot.data}',
                      style: TextStyle(
                        color: myVote.value == true
                            ? Palette.primary
                            : myVote.value == false
                                ? Colors.white.withOpacity(0.5)
                                : Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                _changeVote(myVote.value == false ? null : false);
              },
              child: Icon(
                Icons.arrow_downward,
                size: 20,
                color: myVote.value == false
                    ? Colors.white.withOpacity(0.5)
                    : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

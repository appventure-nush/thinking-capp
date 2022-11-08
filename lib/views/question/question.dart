import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/models/answer.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/services/questions_db.dart';
import 'package:thinking_capp/utils/datetime.dart';
import 'package:thinking_capp/views/answer/answer.dart';
import 'package:thinking_capp/widgets/photo_carousel.dart';
import 'package:thinking_capp/views/question/answer_card.dart';
import 'package:thinking_capp/widgets/app_bar.dart';
import 'package:thinking_capp/widgets/default_feedback.dart';
import 'package:thinking_capp/widgets/loading.dart';
import 'package:thinking_capp/widgets/profile_tile.dart';
import 'package:thinking_capp/widgets/question_tag.dart';
import 'package:thinking_capp/widgets/tab_bar.dart';
import 'package:thinking_capp/widgets/voting_box.dart';

class QuestionView extends StatefulWidget {
  final Question question;

  const QuestionView({Key? key, required this.question}) : super(key: key);

  @override
  State<QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  final _questionsDb = Get.find<QuestionsDbService>();

  String _currentTab = 'Top';
  final List<Answer> _answers = [];
  bool _loadingAnswers = false;

  void _switchTab(String tab) {
    _currentTab = tab;
    _loadMoreAnswers();
  }

  void _loadMoreAnswers() async {
    setState(() => _loadingAnswers = true);
    dynamic startAfter;
    if (_currentTab == 'Top') {
      startAfter = _answers.isEmpty ? 9999 : _answers.last.numVotes;
    } else {
      startAfter = _answers.isEmpty ? DateTime.now() : _answers.last.timestamp;
    }
    final answers = await _questionsDb.getAnswersForQuestion(
      widget.question.id,
      _currentTab == 'Top' ? 'numVotes' : 'timestamp',
      startAfter,
    );
    setState(() {
      _answers.clear();
      _answers.addAll(answers);
      _loadingAnswers = false;
    });
  }

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
                    widget.question.title,
                    style: TextStyle(
                      color: Palette.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (widget.question.text.isNotEmpty) SizedBox(height: 14),
                  if (widget.question.text.isNotEmpty)
                    Text(
                      widget.question.text,
                      style: TextStyle(fontSize: 12),
                    ),
                  if (widget.question.photoUrls.isNotEmpty)
                    SizedBox(height: 20),
                  if (widget.question.photoUrls.isNotEmpty)
                    FractionallySizedBox(
                      widthFactor: 1,
                      child:
                          PhotoCarousel(photoUrls: widget.question.photoUrls),
                    ),
                  SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: widget.question.tags
                        .map((tag) => QuestionTag(label: tag, onPressed: () {}))
                        .toList(),
                  ),
                  SizedBox(height: 16),
                  FractionallySizedBox(
                    widthFactor: 1 + 20 / (Get.width - 72),
                    child: ProfileTile(user: widget.question.poster),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      VotingBox(
                        numVotes:
                            _questionsDb.numVotesStream(widget.question.id),
                        myVote: widget.question.myVote,
                        questionId: widget.question.id,
                      ),
                      Spacer(),
                      Text(
                        formatTimeAgo(widget.question.timestamp),
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
                        '${_answers.length} answers',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      MyTabBar(
                        tabs: const ['Top', 'Newest'],
                        onChanged: _switchTab,
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
                      Get.to(AnswerView(questionId: widget.question.id));
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
                  SizedBox(height: 12),
                  if (_loadingAnswers)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: Loading(),
                      ),
                    )
                  else
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _answers.length,
                      itemBuilder: (context, i) {
                        return AnswerCard(
                          answer: _answers[i],
                          onPressed: () {},
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
  }
}
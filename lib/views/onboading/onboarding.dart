import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/utils/animation.dart';
import 'package:thinking_capp/views/select_subjects/select_subjects.dart';
import 'package:thinking_capp/widgets/default_feedback.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (page) {
                setState(() => _currentPage = page);
              },
              children: [
                _buildPage(
                  'assets/images/onboarding_1.png',
                  'Ask questions anonymously',
                  'Anonymizing questions results in a judgement-free and learning-centric platform. Answers are not anonymous.',
                ),
                _buildPage(
                  'assets/images/onboarding_2.png',
                  'Most relevant answers move to the top',
                  'A democratic voting system ensures this platform is rooted in meritocracy. Each user is assigned a reputation score corresponding to the usefulness of their answers.',
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 50),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: mediumAnimationDuration,
                  width: _currentPage == 0 ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color:
                        Colors.white.withOpacity(_currentPage == 0 ? 1 : 0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: 12),
                AnimatedContainer(
                  duration: mediumAnimationDuration,
                  width: _currentPage == 1 ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color:
                        Colors.white.withOpacity(_currentPage == 1 ? 1 : 0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Spacer(),
                _buildContinueButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(String imageAsset, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(imageAsset),
          SizedBox(height: 50),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 20),
          Text(description),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return DefaultFeedback(
      onPressed: () {
        if (_currentPage == 0) {
          _controller.animateToPage(
            1,
            duration: mediumAnimationDuration,
            curve: Curves.easeInOut,
          );
        } else {
          Get.to(SelectSubjectsView(isOnboarding: true));
        }
      },
      child: Container(
        height: 60,
        padding: EdgeInsets.only(left: 30, right: 20),
        decoration: BoxDecoration(
          color: Palette.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              'Continue',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 28),
            Icon(
              Icons.arrow_forward,
              size: 20,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}

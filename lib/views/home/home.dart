import 'package:flutter/material.dart';
import 'package:thinking_capp/utils/animation.dart';
import 'package:thinking_capp/views/feed/feed.dart';
import 'package:thinking_capp/views/rankings/rankings.dart';
import 'package:thinking_capp/views/my_profile/my_profile.dart';

import 'bottom_sheet.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: mediumAnimationDuration,
        child: [
          const FeedView(),
          const RankingsView(),
          const MyProfileView(),
        ][_currentIndex],
      ),
      bottomSheet: HomeBottomSheet(
        currentIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}

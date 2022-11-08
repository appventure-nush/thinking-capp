import 'package:flutter/material.dart';
import 'package:thinking_capp/views/feed/feed.dart';
import 'package:thinking_capp/views/rankings/rankings.dart';
import 'package:thinking_capp/views/settings/settings.dart';

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
        duration: const Duration(milliseconds: 200),
        child: [
          const FeedView(),
          const RankingsView(),
          const SettingsView(),
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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/widgets/profile_tile.dart';

import 'controller.dart';

class RankingsView extends StatelessWidget {
  const RankingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RankingsController>(
      init: RankingsController(),
      builder: (controller) {
        return SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 32, 40, 32),
                  child: Text(
                    'Most helpful users',
                    style: TextStyle(
                      color: Palette.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final user = controller.rankings[i];
                      return ProfileTile(user: user);
                    },
                    childCount: controller.rankings.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

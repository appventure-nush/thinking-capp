import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/views/select_subjects/subjects.dart';
import 'package:thinking_capp/views/tag/tag.dart';
import 'package:thinking_capp/widgets/default_feedback.dart';

class BrowseSubjects extends StatelessWidget {
  const BrowseSubjects({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 36),
        Text(
          'Browse subjects',
          style: TextStyle(
            color: Palette.primary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 24),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 2,
            ),
            padding: EdgeInsets.zero,
            itemCount: subjects.length,
            itemBuilder: (context, i) {
              return _buildSubjectTile(subjects[i]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectTile(String subject) {
    return DefaultFeedback(
      onPressed: () {
        Get.to(TagView(tag: subject));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Palette.black1,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            subject,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

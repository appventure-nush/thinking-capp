// TODO: improve design

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/views/add_tags/controller.dart';
import 'package:thinking_capp/views/select_subjects/subjects.dart';
import 'package:thinking_capp/widgets/app_bar.dart';
import 'package:thinking_capp/widgets/default_feedback.dart';
import 'package:thinking_capp/widgets/floating_action_button.dart';
import 'package:thinking_capp/widgets/question_tag.dart';

class AddTagsView extends StatelessWidget {
  const AddTagsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddTagsController>(
      init: AddTagsController(),
      builder: (controller) {
        return Scaffold(
          appBar: MyAppBar(title: 'Choose module & add tags'),
          floatingActionButton: MyFloatingActionButton(
            icon: Icons.send_outlined,
            loading: controller.loading,
            onPressed: controller.submit,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Subject',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 14),
                FractionallySizedBox(
                  widthFactor: 1.1,
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 2,
                    ),
                    itemCount: subjects.length,
                    itemBuilder: (context, i) {
                      final subject = subjects[i];
                      return _buildSubjectTile(
                        subject,
                        subject == controller.selectedSubject,
                        () => controller.selectSubject(subject),
                      );
                    },
                  ),
                ),
                SizedBox(height: 40),
                TextField(
                  controller: controller.textController,
                  style: TextStyle(
                    color: Palette.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: 'Enter a tag...',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                  onSubmitted: (value) {
                    controller.addTag(value);
                    controller.textController.clear();
                  },
                ),
                if (controller.tags.isNotEmpty) SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...controller.tags.map(
                      (tag) => QuestionTag(
                        label: tag,
                        onRemoved: () => controller.removeTag(tag),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 300,
                  child: Stack(
                    children: [
                      ListView.builder(
                        padding: const EdgeInsets.only(bottom: 40),
                        itemCount: controller.suggestions.length,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: () {
                              controller.addTag(controller.suggestions[i]);
                              controller.textController.clear();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(controller.suggestions[i]),
                            ),
                          );
                        },
                      ),
                      Container(
                        height: 14,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Palette.black,
                              Palette.black.withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubjectTile(
    String subject,
    bool isSelected,
    Function() onPressed,
  ) {
    return DefaultFeedback(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Palette.primary : Palette.black1,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            subject,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

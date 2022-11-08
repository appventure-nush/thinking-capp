import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/views/add_tags/controller.dart';
import 'package:thinking_capp/widgets/app_bar.dart';
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
          appBar: MyAppBar(title: 'Add question tags'),
          floatingActionButton: MyFloatingActionButton(
            icon: Icons.send_outlined,
            loading: controller.loading,
            onPressed: controller.submit,
          ),
          body: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Expanded(
                  child: ListView.builder(
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

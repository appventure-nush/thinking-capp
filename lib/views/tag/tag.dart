import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/views/feed/question_card.dart';
import 'package:thinking_capp/views/question/question.dart';
import 'package:thinking_capp/views/tag/controller.dart';
import 'package:thinking_capp/widgets/app_bar.dart';

class TagView extends StatelessWidget {
  final String tag;

  const TagView({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TagController>(
      init: TagController(tag),
      builder: (controller) {
        return Scaffold(
          appBar: MyAppBar(
            title: "Questions tagged '$tag'",
            suffixIcons: {Icons.sort: controller.selectSortBy},
          ),
          body: Obx(
            () => RefreshIndicator(
              onRefresh: controller.refreshList,
              child: ListView.builder(
                controller: controller.scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: controller.questions.length,
                itemBuilder: (context, i) {
                  final question = controller.questions[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: QuestionCard(
                      question: question,
                      onPressed: () {
                        Get.to(() => QuestionView(question: question));
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

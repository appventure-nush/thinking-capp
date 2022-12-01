import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/models/question.dart';
import 'package:thinking_capp/widgets/app_bar.dart';
import 'package:thinking_capp/widgets/button.dart';
import 'package:thinking_capp/widgets/default_feedback.dart';
import 'package:thinking_capp/widgets/floating_action_button.dart';

import 'controller.dart';

class WriteQuestionView extends StatelessWidget {
  // this view is used both for writing new questions and editing questions
  // if editing an existing question it must be passed as an argument
  final Question? editQuestion;

  const WriteQuestionView({Key? key, this.editQuestion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WriteQuestionController>(
      init: WriteQuestionController(editQuestion),
      builder: (controller) {
        return Scaffold(
          appBar: MyAppBar(
            title: editQuestion == null ? 'Ask a question' : 'Edit question',
          ),
          floatingActionButton: MyFloatingActionButton(
            icon: Icons.arrow_forward,
            onPressed: controller.submit,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40),
                      Text(
                        'Title',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: controller.titleController,
                        style: TextStyle(
                          color: Palette.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          hintText: 'Enter a title',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: controller.descriptionController,
                        style: TextStyle(
                          color: Palette.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          hintText: "What's your question?",
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                        maxLines: null,
                        minLines: 4,
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Images ${controller.photos.isNotEmpty ? '(${controller.photos.length})' : ''}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: MyButton(
                              height: 60,
                              text: 'Gallery',
                              onPressed: () => controller.addPhoto(true),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: MyButton(
                              height: 60,
                              text: 'Camera',
                              onPressed: () => controller.addPhoto(false),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                _buildImagesList(controller),
                SizedBox(height: 120),
              ],
            ),
          ),
        );
      },
    );
  }

  SizedBox _buildImagesList(WriteQuestionController controller) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        itemCount: controller.photos.length,
        separatorBuilder: (context, i) => SizedBox(width: 12),
        itemBuilder: (context, i) {
          final photo = controller.photos[i];
          return DefaultFeedback(
            onPressed: () => controller.askRemovePhoto(i),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  photo.hasBeenUploaded
                      ? CachedNetworkImage(
                          imageUrl: photo.url,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          photo.file,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.black.withOpacity(0),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      child: Icon(Icons.cancel_outlined, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

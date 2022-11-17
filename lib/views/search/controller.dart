import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/models/question.dart';

class SearchController extends GetxController {
  final focusNode = FocusNode();
  final textController = TextEditingController();

  String selectedCategory = 'Questions';
  final List<Question> questionResults = [];

  @override
  void onReady() {
    focusNode.addListener(() {
      update();
    });
  }

  void selectCategory(String category) {
    selectedCategory = category;
    update();
  }
}

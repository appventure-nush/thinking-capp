import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/services/search.dart';

class SearchController extends GetxController {
  final _search = Get.find<SearchService>();

  final textController = TextEditingController();
  final scrollController = ScrollController();

  bool clickedSearch = false;
  String selectedCategory = 'Questions';
  final List<dynamic> results = [];
  int page = 0;

  Timer? currentTimer;

  @override
  void onReady() {
    textController.addListener(() {
      // only fetch results after 1 second of not typing
      currentTimer?.cancel();
      currentTimer = Timer(Duration(seconds: 1), fetchResults);
    });
    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels > 0) {
        // scrolled to bottom
        _loadMoreResults();
      }
    });
  }

  void clickSearch() {
    clickedSearch = true;
    update();
  }

  void selectCategory(String category) async {
    selectedCategory = category;
    update();
    currentTimer?.cancel();
    fetchResults();
  }

  void fetchResults() async {
    results.clear();
    page = 0;
    if (textController.text.isEmpty) {
      update();
      return;
    }

    if (selectedCategory == 'Questions') {
      results.addAll(await _search.searchQuestions(textController.text, page));
    } else if (selectedCategory == 'Answers') {
      results.addAll(await _search.searchAnswers(textController.text, page));
    } else {
      results.addAll(await _search.searchUsers(textController.text, page));
    }
    update();
  }

  void _loadMoreResults() async {
    page++;
    if (selectedCategory == 'Questions') {
      results.addAll(await _search.searchQuestions(textController.text, page));
    } else if (selectedCategory == 'Answers') {
      results.addAll(await _search.searchAnswers(textController.text, page));
    } else {
      results.addAll(await _search.searchUsers(textController.text, page));
    }
    update();
  }
}

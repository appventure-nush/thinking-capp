import 'package:get/get.dart';

class PaginationData<T> {
  List<T> items;
  dynamic cursor;
  bool reachedEnd;

  PaginationData({
    required this.items,
    required this.cursor,
    required this.reachedEnd,
  });
}

class Paginator<T> {
  final items = RxList<T>();
  int page = 0;
  dynamic _cursor;
  bool reachedEnd = false;
  RxBool loadingMore = false.obs;
  final Future<PaginationData<T>> Function(int page, dynamic cursor) fetcher;

  Paginator({required this.fetcher});

  Future<void> refresh() async {
    page = 0;
    _cursor = null;
    reachedEnd = false;
    items.clear();
    await nextPage();
  }

  Future<void> nextPage() async {
    if (reachedEnd) return;
    loadingMore.value = true;
    final result = await fetcher(page, _cursor);
    items.addAll(result.items);
    page++;
    _cursor = result.cursor;
    reachedEnd = result.reachedEnd;
    loadingMore.value = false;
  }
}

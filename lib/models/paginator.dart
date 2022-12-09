import 'package:get/get.dart';

class PaginationData<T> {
  List<T> data;
  dynamic cursor;
  bool reachedEnd;

  PaginationData(this.data, this.cursor, this.reachedEnd);
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
    items.addAll(result.data);
    page++;
    _cursor = result.cursor;
    reachedEnd = result.reachedEnd;
    loadingMore.value = false;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_ui_sign/services/kamus_service.dart';

class KamusController extends ChangeNotifier {
  List<dynamic> kamusData = [];
  List<dynamic> filteredData = [];
  bool isLoading = true;

  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  void init() async {
    try {
      kamusData = await fetchKamusDataFromSupabase();
      filteredData = List.from(kamusData);
    } catch (e) {
      print('Gagal Fetch: $e');
    }
    isLoading = false;

    searchController.addListener(onSearchChanged);
    notifyListeners();
  }

  void onSearchChanged() {
    final query = searchController.text.toLowerCase();
    filteredData = kamusData.where((item) {
      final title = item['title'].toString().toLowerCase();
      return title.contains(query);
    }).toList();
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
  }

  void scrollToFirstMatch(String query) {
    final index = filteredData.indexWhere((item) =>
        item['title'].toString().toLowerCase().contains(query.toLowerCase()));

    if (index != -1) {
      const double rowHeight = 200;
      scrollController.animateTo(
        (index ~/ 2) * rowHeight,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}

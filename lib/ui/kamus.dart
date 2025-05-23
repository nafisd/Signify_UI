import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_ui_sign/utils/cards.dart';
import 'package:flutter_ui_sign/utils/cards_detail.dart';

class KamusPage extends StatefulWidget {
  @override
  _KamusPageState createState() => _KamusPageState();
}

class _KamusPageState extends State<KamusPage> {
  List<dynamic> kamusData = [];
  List<dynamic> filteredData = [];
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadKamusData();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> loadKamusData() async {
    final String response =
        await rootBundle.loadString('assets/kamus_data.json');
    final data = json.decode(response);
    setState(() {
      kamusData = data;
      filteredData = data;
    });
  }

  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredData = kamusData.where((item) {
        final title = item['title'].toString().toLowerCase();
        return title.contains(query);
      }).toList();
    });
  }

  void _scrollToFirstMatch(String query) {
    final index = filteredData.indexWhere((item) =>
        item['title'].toString().toLowerCase().contains(query.toLowerCase()));

    if (index != -1) {
      final double rowHeight = 200; // kira-kira tinggi 1 grid item termasuk spacing
      scrollController.animateTo(
        (index ~/ 2) * rowHeight, // index ~/ 2 karena 2 kolom per baris
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Kamus Abjad Bahasa Isyarat',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: kamusData.isEmpty
            ? Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/allPage/background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(child: CircularProgressIndicator()),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Search Bar
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Cari huruf...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onSubmitted: (value) {
                        _scrollToFirstMatch(value);
                      },
                    ),
                    SizedBox(height: 16),

                    // Grid View
                    Expanded(
                      child: GridView.builder(
                        controller: scrollController,
                        itemCount: filteredData.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          final item = filteredData[index];
                          return KamusCard(
                            title: item['title'],
                            imagePath: item['image'],
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CardDetailPage(letter: item['title']),
                              ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

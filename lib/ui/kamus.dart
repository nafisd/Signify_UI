import 'package:flutter/material.dart';
import 'package:flutter_ui_sign/utils/cards.dart';
import 'package:flutter_ui_sign/utils/cards_detail.dart';
import 'package:flutter_ui_sign/controllers/kamus_controller.dart';

class KamusPage extends StatefulWidget {
  @override
  _KamusPageState createState() => _KamusPageState();
}

class _KamusPageState extends State<KamusPage> {
  final controller = KamusController();

  @override
  void initState() {
    super.initState();
    controller.init();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF176),
        elevation: 4,
        centerTitle: true,
        title: const Text(
          'Kamus Abjad Bahasa Isyarat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF424242),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/allPage/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: controller.isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Cari huruf...',
                          suffixIcon: controller.searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: controller.clearSearch,
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onSubmitted: controller.scrollToFirstMatch,
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: GridView.builder(
                          controller: controller.scrollController,
                          itemCount: controller.filteredData.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            final item = controller.filteredData[index];
                            return KamusCard(
                              title: item['title'],
                              imagePath : item['image_url'],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CardDetailPage(letter: item['title']),
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
      ),
    );
  }
}
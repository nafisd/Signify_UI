import 'package:flutter/material.dart';

class KamusCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback? onTap;

  const KamusCard({
    Key? key,
    required this.title,
    required this.imagePath,
    this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (MediaQuery.of(context).size.width - 48) / 2,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.yellow[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Huruf besar di atas
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
      
            // Gambar tangan/objek
            Image.asset(
              imagePath,
              width: 100,
              height: 100,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 90,
                height: 90,
                color: Colors.grey[300],
                alignment: Alignment.center,
                child: Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

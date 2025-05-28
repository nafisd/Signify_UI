import 'package:flutter/material.dart';
import 'package:flutter_ui_sign/QuizPage/quiz_camera.dart';
import 'package:flutter_ui_sign/QuizPage/quiz_choice.dart';
import 'package:camera/camera.dart';

class QuizHomePage extends StatelessWidget {
  final List<CameraDescription> cameras;
  const QuizHomePage({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1F5FE),
      appBar: AppBar(
        backgroundColor: const Color (0xFF81D4FA),
        title: const Text("Tebak Tebakan Isyarat"),
        elevation: 0,
        ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/allPage/quiz.png', height: 180),
              SizedBox(height: 30,),
              const Text(
                "Pilih jenis permainan!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30,),
              
              ElevatedButton.icon(
                icon: const Icon(Icons.touch_app),
                label: const Text("Tebak-Tebakan Pilihan"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QuizChoicePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFF176),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.videocam),
                label: const Text("Tebak Lewat Kamera"),
                onPressed: () { 
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizCameraPage(camera: cameras.first),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




// onPressed: () {
//               Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (_) => QuizCameraPage(camera: cameras.first),
//                  ),
//                );
//              },
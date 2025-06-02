import 'package:flutter/material.dart';
import 'package:flutter_ui_sign/QuizPage/controller/quiz_controller.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_ui_sign/QuizPage/models/quiz_model.dart';

class QuizChoicePage extends StatefulWidget {
  const QuizChoicePage({super.key});

  @override
  State<QuizChoicePage> createState() => _QuizChoicePageState();
}

class _QuizChoicePageState extends State<QuizChoicePage> {
  @override
  void initState() {
    super.initState();
    final controller = Provider.of<QuizController>(context, listen: false);
    controller.initQuiz();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<QuizController>(context);

    if (controller.questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = controller.questions[controller.currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFE1F5FE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF81D4FA),
        title: const Text("Tebak Isyarat (ABCD)"),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Soal ${controller.currentIndex + 1} dari ${controller.questions.length}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9C4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Image.network(
                    question.imageAsset,
                    height: 180,
                    errorBuilder: (context, error, stackTrace) =>
                        const Text("Gagal memuat gambar"),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Tebak huruf dari isyarat ini:",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 12),
                ...question.options.map((option) {
                  final isSelected = option == controller.selectedAnswer;
                  final isCorrect = option == question.correctAnswer;

                  Color? color;
                  if (controller.selectedAnswer != null) {
                    if (isSelected && isCorrect) color = Colors.green;
                    else if (isSelected && !isCorrect) color = Colors.red;
                    else if (isCorrect) color = Colors.green.withOpacity(0.6);
                    else color = Colors.grey.shade300;
                  } else {
                    color = const Color(0xFFFFF9C4);
                  }

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: controller.selectedAnswer == null
                          ? () => controller.checkAnswer(option)
                          : null,
                      child: Text(
                        option,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          if (controller.showResultPopup)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                decoration: BoxDecoration(
                  color: controller.isCorrect ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black26),
                ),
                child: Text(
                  controller.isCorrect ? "Benar! 🎉" : "Salah! 😢",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: controller.confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ui_sign/QuizPage/models/quiz_model.dart';

class QuizChoicePage extends StatefulWidget {
  const QuizChoicePage({super.key});

  @override
  State<QuizChoicePage> createState() => _QuizChoicePageState();
}

class _QuizChoicePageState extends State<QuizChoicePage>
    with SingleTickerProviderStateMixin {
  final List<QuizItem> _questions = [
    QuizItem(
      imageAsset: 'assets/Kamus/B/1.png',
      correctAnswer: 'B',
      options: ['A', 'B', 'C', 'D'],
    ),
    QuizItem(
      imageAsset: 'assets/Kamus/D/1.png',
      correctAnswer: 'D',
      options: ['B', 'C', 'D', 'E'],
    ),
  ];

  int _currentIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  Timer? _timer;
  int _remainingSeconds = 10;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _startTimer();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  void _startTimer() {
    _remainingSeconds = 10;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _checkAnswer(null); // timeout
      }
    });
  }

  void _checkAnswer(String? selected) {
    _timer?.cancel();
    final correct = selected == _questions[_currentIndex].correctAnswer;

    setState(() {
      _selectedAnswer = selected;
      if (correct) _score++;
    });
  }

  void _nextQuestion() async {
    _fadeController.reverse();

    await Future.delayed(const Duration(milliseconds: 500));
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
      });
      _fadeController.forward();
      _startTimer();
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Selesai!"),
          content: Text("Skor akhir kamu: $_score / ${_questions.length}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 0;
                  _score = 0;
                  _selectedAnswer = null;
                });
                _fadeController.forward();
                _startTimer();
              },
              child: const Text("Ulangi"),
            )
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];

   return Scaffold(
  backgroundColor: const Color(0xFFE1F5FE), // Biru muda seperti kamus
  appBar: AppBar(
    backgroundColor: const Color(0xFF81D4FA),
    title: const Text("Tebak Isyarat (ABCD)"),
    elevation: 0,
  ),
  body: FadeTransition(
    opacity: _fadeAnimation,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "Soal ${_currentIndex + 1} dari ${_questions.length}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9C4), // Kuning lembut
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Image.asset(
              question.imageAsset,
              height: 180,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Tebak huruf dari isyarat ini:",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 12),
          ...question.options.map((option) {
            final isSelected = option == _selectedAnswer;
            final isCorrect = option == question.correctAnswer;

            Color? color;
            if (_selectedAnswer != null) {
              if (isSelected && isCorrect) color = Colors.green;
              else if (isSelected && !isCorrect) color = Colors.red;
              else if (isCorrect) color = Colors.green.withOpacity(0.6);
              else color = Colors.grey.shade300;
            } else {
              color = const Color(0xFFFFF9C4); // default kuning lembut
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
                onPressed: _selectedAnswer == null ? () => _checkAnswer(option) : null,
                child: Text(
                  option,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          if (_selectedAnswer != null)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: _nextQuestion,
              child: const Text("Lanjut"),
            ),
        ],
      ),
    ),
  ),
);

  }
}

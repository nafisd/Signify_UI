import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vibration/vibration.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_ui_sign/QuizPage/models/quiz_model.dart';

class QuizController extends ChangeNotifier {
  final List<QuizItem> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool _showResultPopup = false;
  bool _isCorrect = false;
  Timer? _nextQuestionTimer;


  ConfettiController confettiController = ConfettiController(duration: const Duration(seconds: 2));

  List<QuizItem> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get score => _score;
  String? get selectedAnswer => _selectedAnswer;
  bool get showResultPopup => _showResultPopup;
  bool get isCorrect => _isCorrect;

  Future<void> initQuiz() async {
    final response = await Supabase.instance.client
        .from('quiz_question')
        .select()
        .limit(10);

    final data = response as List;
    _questions.clear();
    _questions.addAll(data.map((e) => QuizItem.fromMap(e)).toList());
    _questions.shuffle();

    _currentIndex = 0;
    _score = 0;
    _selectedAnswer = null;
    _showResultPopup = false;

    notifyListeners();
  }

  Future<void> checkAnswer(String selected) async {
    final currentQuestion = _questions[_currentIndex];
    _selectedAnswer = selected;
    _isCorrect = selected == currentQuestion.correctAnswer;
    _showResultPopup = true;

    if (_isCorrect) {
      _score++;
      confettiController.play();
    } else {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 300);
      }
    }

    notifyListeners();

    _nextQuestionTimer = Timer(const Duration(seconds: 3), nextQuestion);
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _selectedAnswer = null;
      _showResultPopup = false;
      notifyListeners();
    } else {
      // show final popup handled by UI
    }
  }

  void restartQuiz() {
    _currentIndex = 0;
    _score = 0;
    _selectedAnswer = null;
    _showResultPopup = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _nextQuestionTimer?.cancel();
    confettiController.dispose();
    super.dispose();
  }
}

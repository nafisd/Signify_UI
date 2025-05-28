class QuizQuestion {
  final String correctAnswer;

  QuizQuestion({required this.correctAnswer});
}

class QuizCameraController {
  final List<QuizQuestion> items = [
    QuizQuestion(correctAnswer: 'A'),
    QuizQuestion(correctAnswer: 'B'),
    QuizQuestion(correctAnswer: 'C'),
    QuizQuestion(correctAnswer: 'D'),
    QuizQuestion(correctAnswer: 'E'),
  ];

  int _currentIndex = 0;
  int score = 0;

  QuizQuestion get currentQuestion => items[_currentIndex];

  bool checkAnswer(String prediction) {
    final isCorrect = prediction.toUpperCase() == currentQuestion.correctAnswer.toUpperCase();
    if (isCorrect) score++;
    return isCorrect;
  }

  bool next() {
    if (_currentIndex < items.length - 1) {
      _currentIndex++;
      return true;
    }
    return false;
  }

  void reset() {
    _currentIndex = 0;
    score = 0;
  }
}

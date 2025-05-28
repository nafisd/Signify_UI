class QuizItem {
  final String imageAsset;
  final String correctAnswer;
  final List<String> options;

  QuizItem({
    required this.imageAsset,
    required this.correctAnswer,
    this.options = const [], // default kosong (untuk mode kamera)
  });
}

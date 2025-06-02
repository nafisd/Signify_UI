class QuizItem {
  final String soal;
  final String imageAsset;
  final String correctAnswer;
  final List<String> options;

  QuizItem({
    required this.soal,
    required this.imageAsset,
    required this.correctAnswer,
    required this.options,
  });

  factory QuizItem.fromMap(Map<String, dynamic> map) {
    return QuizItem(
      soal: map['soal'] as String,
      imageAsset: map['image_url'] ?? '',
      correctAnswer: map['correct_answer'] ?? '',
      options: List<String>.from(map['options'] ?? []),
    );
  }
}

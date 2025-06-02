import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_ui_sign/controllers/camera_controller.dart';
import 'package:flutter_ui_sign/QuizPage/controller/quiz_controller.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';

class QuizCameraPage extends StatefulWidget {
  final CameraDescription camera;
  const QuizCameraPage({super.key, required this.camera});

  @override
  State<QuizCameraPage> createState() => _QuizCameraPageState();
}

class _QuizCameraPageState extends State<QuizCameraPage> {
  late CameraControllerService _cameraService;
  late Future<void> _initializeControllerFuture;
  Timer? _predictionTimer;

  @override
  void initState() {
    super.initState();
    _cameraService = CameraControllerService(camera: widget.camera);
    _initializeControllerFuture = _cameraService.initialize();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final quizController = Provider.of<QuizController>(context, listen: false);
      quizController.initQuiz();
    });

    _predictionTimer = Timer.periodic(const Duration(seconds: 2), (_) => _captureAndCheckAnswer());
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _predictionTimer?.cancel();
    super.dispose();
  }

  Future<void> _captureAndCheckAnswer() async {
    final quizController = Provider.of<QuizController>(context, listen: false);
    if (quizController.showResultPopup) return; // Skip if waiting

    final result = await _cameraService.captureAndPredict();
    if (result != null) {
      final predictedLabel = result['label'] as String;
      await quizController.checkAnswer(predictedLabel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizController>(
      builder: (context, quiz, _) {
        final question = quiz.questions.isNotEmpty
            ? quiz.questions[quiz.currentIndex]
            : null;

        return Scaffold(
          backgroundColor: const Color(0xFFE0F7FA),
          appBar: AppBar(
            title: const Text('Quiz Kamera + AI SIBI'),
            backgroundColor: const Color(0xFF4DD0E1),
          ),
          body: question == null
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: FutureBuilder<void>(
                            future: _initializeControllerFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                return OverflowBox(
                                  alignment: Alignment.center,
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                      width: _cameraService.controller.value.previewSize!.height,
                                      height: _cameraService.controller.value.previewSize!.width,
                                      child: CameraPreview(_cameraService.controller),
                                    ),
                                  ),
                                );
                              } else {
                                return const Center(child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Soal ${quiz.currentIndex + 1}/${quiz.questions.length}',
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                question.soal,
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Tunjukkan jawaban dalam SIBI ke kamera',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 12),
                              if (quiz.selectedAnswer != null)
                                Text(
                                  'Jawaban kamu: ${quiz.selectedAnswer}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: quiz.isCorrect ? Colors.green : Colors.red,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (quiz.showResultPopup)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                quiz.isCorrect ? Icons.check_circle : Icons.cancel,
                                size: 64,
                                color: quiz.isCorrect ? Colors.green : Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                quiz.isCorrect ? 'Benar!' : 'Salah!',
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: ConfettiWidget(
                        confettiController: quiz.confettiController,
                        blastDirectionality: BlastDirectionality.explosive,
                        shouldLoop: false,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

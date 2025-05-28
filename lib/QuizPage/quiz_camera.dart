import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ui_sign/QuizPage/controller/quiz_controller.dart';
import 'package:flutter_ui_sign/controllers/camera_controller.dart';
import 'package:camera/camera.dart';

class QuizCameraPage extends StatefulWidget {
  final CameraDescription camera;
  const QuizCameraPage({Key? key, required this.camera}) : super(key: key);

  @override
  State<QuizCameraPage> createState() => _QuizCameraPageState();
}

class _QuizCameraPageState extends State<QuizCameraPage> with TickerProviderStateMixin {
  late CameraControllerService _cameraService;
  late Future<void> _initializeCamera;
  final QuizCameraController _quizController = QuizCameraController();

  String? _predictedLabel;
  bool? _isCorrect;
  bool _hasAnswered = false;

  DateTime _lastPredictionTime = DateTime.now();
  int _remainingSeconds = 10;
  Timer? _countdownTimer;
  Timer? _predictionTimer;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _cameraService = CameraControllerService(camera: widget.camera);
    _initializeCamera = _cameraService.initialize();

    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    _initializeCamera.then((_) {
      if (mounted) {
        _startCountdown();
        _startPredictionLoop();
      }
    });
  }

  void _startCountdown() {
    _remainingSeconds = 10;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        if (!_hasAnswered) {
          _showIncorrectPopup();
        }
      }
    });
  }

  void _startPredictionLoop() {
    _predictionTimer?.cancel();
    _predictionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _runPrediction();
      }
    });
  }

  void _showIncorrectPopup() {
  _countdownTimer?.cancel();
  _predictionTimer?.cancel();
  _hasAnswered = true;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: const Text("Waktu Habis!"),
      content: Text(
        "Ayo Kamu Pasti Bisa!!!!",
        style: const TextStyle(fontSize: 18),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _nextQuestion();
            _startPredictionLoop();
          },
          child: const Text("Lanjut"),
        ),
      ],
    ),
  );
}


  Future<void> _runPrediction() async {
    if (_hasAnswered) return;

    final result = await _cameraService.captureAndPredict();
    if (result == null) return;

    final label = result['label'] as String;
    final now = DateTime.now();

    if (now.difference(_lastPredictionTime).inSeconds < 2) return;

    final correct = _quizController.checkAnswer(label);
    if (correct) {
      _hasAnswered = true;
      _fadeController.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: 800));
      _nextQuestion();
    }

    setState(() {
      _predictedLabel = label;
      _isCorrect = correct;
      _lastPredictionTime = now;
    });
  }

  void _nextQuestion() {
    _countdownTimer?.cancel();
    _hasAnswered = false;

    if (_quizController.next()) {
      setState(() {
        _predictedLabel = null;
        _isCorrect = null;
        _remainingSeconds = 10;
      });
      _startCountdown();
    } else {
      _predictionTimer?.cancel();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Selesai!"),
          content: Text("Skor akhir: ${_quizController.score}/${_quizController.items.length}"),
          actions: [
            TextButton(
              onPressed: () {
                _quizController.reset();
                _hasAnswered = false;
                Navigator.pop(context);
                setState(() {});
                _startCountdown();
                _startPredictionLoop();
              },
              child: const Text("Ulangi"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup"),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _countdownTimer?.cancel();
    _predictionTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = _quizController.currentQuestion;
    final currentLetter = question.correctAnswer;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tebak Lewat Kamera"),
        backgroundColor: const Color(0xFF81D4FA),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<void>(
              future: _initializeCamera,
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
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFFFF9C4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    "Tebak huruf ini: $currentLetter",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Prediksi: ${_predictedLabel ?? '-'}',
                  style: TextStyle(
                    fontSize: 18,
                    color: _isCorrect == true ? Colors.green : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _remainingSeconds / 10,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.pinkAccent,
                  minHeight: 10,
                ),
                const SizedBox(height: 4),
                Text(
                  "Waktu: $_remainingSeconds detik",
                  style: const TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_ui_sign/controllers/camera_controller.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;
  const CameraScreen({super.key, required this.camera});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraControllerService _cameraService;
  late Future<void> _initializeControllerFuture;

  String? _predictionLabel;
  double? _predictionConfidence;
  String _fullText = '';
  String? _lastLabel;
  DateTime _lastAppendTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _cameraService = CameraControllerService(camera: widget.camera);
    _initializeControllerFuture = _cameraService.initialize();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _captureAndPredict();
      }
    });
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  Future<void> _captureAndPredict() async {
    final result = await _cameraService.captureAndPredict();
    if (result != null) {
      final label = result['label'] as String;
      final confidence = result['confidence'] as double;
      final now = DateTime.now();

      setState(() {
        _predictionLabel = label;
        _predictionConfidence = confidence;

        if (label != _lastLabel &&
            now.difference(_lastAppendTime).inSeconds >= 2) {
          _fullText += ' $label';
          _lastLabel = label;
          _lastAppendTime = now;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1F5FE),
      appBar: AppBar(
        title: const Text('Kamera + AI SIBI'),
        backgroundColor: const Color(0xFF81D4FA),
      ),
      body: Column(
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
          if (_predictionLabel != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Prediksi: $_predictionLabel\nConfidence: ${(_predictionConfidence ?? 0.0).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Kalimat: $_fullText',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _fullText = '';
              });
            },
            icon: const Icon(Icons.clear),
            label: const Text('Hapus Kalimat'),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;
  const CameraScreen({super.key, required this.camera});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  String? _predictionLabel;
  double? _predictionConfidence;
  String _fullText = '';
  String? _lastLabel;
  DateTime _lastAppendTime = DateTime.now();
  bool _isLoading = false;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();

    // Timer untuk prediksi berkala
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _captureFrameAndPredict();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _captureFrameAndPredict() async {
    if (_isLoading || _isCapturing) return;
    _isCapturing = true;

    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();

      setState(() {
        _isLoading = true;
      });

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.10.0.231:5000/predict'), // Ganti IP sesuai server
      );
      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var decoded = jsonDecode(responseData);

        final label = decoded['label'];
        final confidence = (decoded['confidence'] as num).toDouble();

        setState(() {
          _predictionLabel = label;
          _predictionConfidence = confidence;

          // Tambahkan ke kalimat jika berbeda dan sudah jeda cukup
          final now = DateTime.now();
          if (label != _lastLabel &&
              now.difference(_lastAppendTime).inSeconds >= 2) {
            _fullText += ' $label';
            _lastLabel = label;
            _lastAppendTime = now;
          }

          _isLoading = false;
        });
      } else {
        print('Server error: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e, st) {
      print('Prediction error: $e');
      print(st);
      setState(() {
        _isLoading = false;
      });
    } finally {
      _isCapturing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1F5FE), // Warna ramah anak
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
                        width: _controller.value.previewSize!.height,
                        height: _controller.value.previewSize!.width,
                        child: CameraPreview(_controller)
                      )
                    )
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

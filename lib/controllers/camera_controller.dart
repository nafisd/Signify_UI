import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CameraControllerService extends ChangeNotifier{
  final CameraDescription camera;
  late CameraController _controller;
  bool _isInitialized = false;
  bool _isLoading = false;
  bool _isCapturing = false;

  CameraController get controller => _controller;
  bool get isLoading => _isLoading;

  CameraControllerService({required this.camera});

  Future<void> initialize() async {
    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _controller.initialize();
    _isInitialized = true;
  }

  Future<Map<String, dynamic>?> captureAndPredict() async {
    if (!_isInitialized || _isLoading || _isCapturing) return null;
    _isCapturing = true;

    try {
      final image = await _controller.takePicture();
      _isLoading = true;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.18.130:5000/predict'),
      );
      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var decoded = jsonDecode(responseData);
        return {
          'label': decoded['label'],
          'confidence': (decoded['confidence'] as num).toDouble(),
        };
      } else {
        print('Server error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Prediction error: $e');
      return null;
    } finally {
      _isLoading = false;
      _isCapturing = false;
    }
  }

  void dispose() {
    _controller.dispose();
  }
}

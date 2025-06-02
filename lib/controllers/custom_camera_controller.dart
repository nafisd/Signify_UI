import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CustomCameraController with ChangeNotifier {
  CameraController? _controller;
  CameraController? get controller => _controller;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get isInitialized => _controller?.value.isInitialized ?? false;

Future<void> initialize(CameraDescription camera) async {
  if (_controller != null && _controller!.value.isInitialized) return;

  _isLoading = true;
  notifyListeners();

  _controller = CameraController(
    camera,
    ResolutionPreset.medium,
    enableAudio: false,
  );

  try {
    await _controller!.initialize();
  } catch (e) {
    debugPrint("Camera initialization error: $e");
  }

  _isLoading = false;
  notifyListeners();
}

  Future<XFile?> takePicture() async {
    if (_controller != null &&
        _controller!.value.isInitialized &&
        !_controller!.value.isTakingPicture) {
      try {
        return await _controller!.takePicture();
      } catch (e) {
        debugPrint("Take picture error: $e");
      }
    }
    return null;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

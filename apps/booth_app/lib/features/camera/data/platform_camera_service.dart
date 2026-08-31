import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import '../domain/camera_service.dart';

class PlatformCameraService implements CameraService {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;

  @override
  CameraController? get controller => _controller;

  @override
  bool get isInitialized => _isInitialized && _controller != null && _controller!.value.isInitialized;

  @override
  List<CameraDescription> get availableCamerasList => _cameras;

  @override
  Future<void> initialize() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        debugPrint('No physical camera detected on system.');
        _isInitialized = false;
        return;
      }

      // Default to front-facing camera if available, otherwise first available
      CameraDescription selectedCamera = _cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );

      await switchCamera(selectedCamera);
    } catch (e) {
      debugPrint('Error initializing camera service: $e');
      _isInitialized = false;
    }
  }

  @override
  Future<void> switchCamera(CameraDescription camera) async {
    if (_controller != null) {
      await _controller!.dispose();
    }

    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _controller!.initialize();
      _isInitialized = true;
    } catch (e) {
      debugPrint('Failed to initialize camera controller: $e');
      _isInitialized = false;
    }
  }

  @override
  Future<XFile?> capturePhoto() async {
    if (!isInitialized || _controller == null || _controller!.value.isTakingPicture) {
      return null;
    }

    try {
      final XFile photo = await _controller!.takePicture();
      return photo;
    } catch (e) {
      debugPrint('Failed to capture photo: $e');
      return null;
    }
  }

  @override
  Future<void> dispose() async {
    if (_controller != null) {
      await _controller!.dispose();
      _controller = null;
    }
    _isInitialized = false;
  }
}

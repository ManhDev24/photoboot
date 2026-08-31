import 'package:camera/camera.dart';

abstract class CameraService {
  Future<void> initialize();
  Future<void> dispose();
  CameraController? get controller;
  bool get isInitialized;
  List<CameraDescription> get availableCamerasList;
  Future<XFile?> capturePhoto();
  Future<void> switchCamera(CameraDescription camera);
}

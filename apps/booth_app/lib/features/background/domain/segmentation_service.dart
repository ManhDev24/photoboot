import 'package:flutter/foundation.dart';

abstract class SegmentationService {
  Future<void> initialize();
  Future<Uint8List?> generateForegroundMask(Uint8List cameraFrameBytes, {int width = 512, int height = 512});
  void dispose();
}

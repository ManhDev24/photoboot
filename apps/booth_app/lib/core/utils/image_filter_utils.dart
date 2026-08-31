import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageFilterUtils {
  /// Applies a 4x5 ColorMatrix to image raw bytes using Dart ui.Canvas.
  static Future<Uint8List> applyColorMatrixFilter(
    Uint8List inputBytes,
    List<double> matrix,
  ) async {
    try {
      final codec = await ui.instantiateImageCodec(inputBytes);
      final frameInfo = await codec.getNextFrame();
      final ui.Image image = frameInfo.image;

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));

      final paint = Paint()
        ..colorFilter = ColorFilter.matrix(matrix);

      canvas.drawImage(image, Offset.zero, paint);

      final picture = recorder.endRecording();
      final filteredImage = await picture.toImage(image.width, image.height);
      final byteData = await filteredImage.toByteData(format: ui.ImageByteFormat.png);

      image.dispose();
      filteredImage.dispose();

      if (byteData != null) {
        return byteData.buffer.asUint8List();
      }
    } catch (e) {
      debugPrint('Error applying color matrix filter: $e');
    }
    return inputBytes;
  }
}

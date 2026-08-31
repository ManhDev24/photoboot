import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../photo/domain/captured_photo.dart';
import '../../template/domain/template_definition.dart';

class PhotoCompositor {
  /// Composites captured photos onto a high-resolution template canvas.
  static Future<ui.Image> renderComposite({
    required List<CapturedPhoto> photos,
    required TemplateDefinition template,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(
        0,
        0,
        template.layout.canvasWidth.toDouble(),
        template.layout.canvasHeight.toDouble(),
      ),
    );

    // 1. Draw Background Fill
    final bgPaint = Paint()..color = const Color(0xFF0F172A);
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        template.layout.canvasWidth.toDouble(),
        template.layout.canvasHeight.toDouble(),
      ),
      bgPaint,
    );

    // 2. Draw Photo Slots
    final slots = template.layout.photoSlots;
    final slotPaint = Paint()..color = const Color(0xFF1E293B);
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;

    for (int i = 0; i < slots.length && i < photos.length; i++) {
      final slot = slots[i];
      final rect = Rect.fromLTWH(
        slot.x * template.layout.canvasWidth,
        slot.y * template.layout.canvasHeight,
        slot.width * template.layout.canvasWidth,
        slot.height * template.layout.canvasHeight,
      );

      // Draw slot placeholder background & border
      canvas.drawRect(rect, slotPaint);
      canvas.drawRect(rect, borderPaint);
    }

    // 3. Draw Text Elements
    for (final element in template.elements) {
      if (element.type == 'TEXT') {
        final textPainter = TextPainter(
          text: TextSpan(
            text: element.content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        );
        textPainter.layout(
          maxWidth: element.width * template.layout.canvasWidth,
        );
        textPainter.paint(
          canvas,
          Offset(
            element.x * template.layout.canvasWidth,
            element.y * template.layout.canvasHeight,
          ),
        );
      }
    }

    final picture = recorder.endRecording();
    return picture.toImage(
      template.layout.canvasWidth,
      template.layout.canvasHeight,
    );
  }
}

import 'package:flutter/material.dart';

class ARStickerPainter extends CustomPainter {
  final String activeEffectId;

  ARStickerPainter({required this.activeEffectId});

  @override
  void paint(Canvas canvas, Size size) {
    if (activeEffectId == 'none') return;

    final double cx = size.width * 0.5;
    final double cy = size.height * 0.35; // Head region default center
    final double faceWidth = size.width * 0.38;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    if (activeEffectId == 'crown') {
      textPainter.text = TextSpan(
        text: '👑',
        style: TextStyle(fontSize: faceWidth * 0.85),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(cx - textPainter.width / 2, cy - faceWidth * 0.85));
    } else if (activeEffectId == 'glasses') {
      textPainter.text = TextSpan(
        text: '😎',
        style: TextStyle(fontSize: faceWidth * 0.9),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(cx - textPainter.width / 2, cy - faceWidth * 0.3));
    } else if (activeEffectId == 'bunny') {
      textPainter.text = TextSpan(
        text: '🐰',
        style: TextStyle(fontSize: faceWidth * 1.1),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(cx - textPainter.width / 2, cy - faceWidth * 1.05));
    } else if (activeEffectId == 'horns') {
      textPainter.text = TextSpan(
        text: '😈',
        style: TextStyle(fontSize: faceWidth * 0.85),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(cx - textPainter.width / 2, cy - faceWidth * 0.8));
    } else if (activeEffectId == 'hearts') {
      textPainter.text = TextSpan(
        text: '❤️',
        style: TextStyle(fontSize: faceWidth * 0.7),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(cx - textPainter.width / 2 + 60, cy - faceWidth * 0.6));
      textPainter.paint(canvas, Offset(cx - textPainter.width / 2 - 60, cy - faceWidth * 0.7));
    } else if (activeEffectId == 'fire') {
      textPainter.text = TextSpan(
        text: '🔥',
        style: TextStyle(fontSize: faceWidth * 0.9),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(cx - textPainter.width / 2, cy + faceWidth * 0.5));
    }
  }

  @override
  bool shouldRepaint(covariant ARStickerPainter oldDelegate) {
    return oldDelegate.activeEffectId != activeEffectId;
  }
}

import 'package:flutter/material.dart';

class ARStickerPainter extends CustomPainter {
  final String activeEffectId;
  final double animationProgress;

  ARStickerPainter({
    required this.activeEffectId,
    this.animationProgress = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (activeEffectId == 'none') return;

    // Dynamic Face Detection Region Estimation
    final double cx = size.width * 0.5;
    final double cy = size.height * 0.38;
    final double faceWidth = size.width * 0.35;
    final double faceHeight = faceWidth * 1.3;

    final Paint paint = Paint()..style = PaintingStyle.fill;
    final Paint strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.black87;

    if (activeEffectId == 'crown') {
      _drawRoyalCrown(canvas, cx, cy - faceHeight * 0.45, faceWidth, paint, strokePaint);
    } else if (activeEffectId == 'glasses') {
      _drawSunglasses(canvas, cx, cy - faceHeight * 0.08, faceWidth, paint, strokePaint);
    } else if (activeEffectId == 'bunny') {
      _drawBunnyEars(canvas, cx, cy - faceHeight * 0.5, faceWidth, paint, strokePaint);
    } else if (activeEffectId == 'horns') {
      _drawDevilHorns(canvas, cx, cy - faceHeight * 0.4, faceWidth, paint, strokePaint);
    } else if (activeEffectId == 'hearts') {
      _drawFloatingHearts(canvas, size, cx, cy, faceWidth);
    } else if (activeEffectId == 'fire') {
      _drawFireAura(canvas, cx, cy, faceWidth, paint);
    }
  }

  void _drawRoyalCrown(Canvas canvas, double cx, double topY, double width, Paint paint, Paint stroke) {
    final Path path = Path();
    final double w = width * 0.8;
    final double h = w * 0.65;
    final double left = cx - w / 2;

    path.moveTo(left, topY);
    path.lineTo(left + w * 0.2, topY - h * 0.7);
    path.lineTo(left + w * 0.4, topY - h * 0.35);
    path.lineTo(cx, topY - h);
    path.lineTo(left + w * 0.6, topY - h * 0.35);
    path.lineTo(left + w * 0.8, topY - h * 0.7);
    path.lineTo(left + w, topY);
    path.close();

    // Gold Gradient
    paint.shader = const LinearGradient(
      colors: [Color(0xFFF59E0B), Color(0xFFFCD34D), Color(0xFFD97706)],
    ).createShader(Rect.fromLTWH(left, topY - h, w, h));

    canvas.drawPath(path, paint);
    canvas.drawPath(path, stroke);

    // Red Jewels
    final jewelPaint = Paint()..color = const Color(0xFFDC2626);
    canvas.drawCircle(Offset(cx, topY - h * 0.85), 6, jewelPaint);
    canvas.drawCircle(Offset(left + w * 0.2, topY - h * 0.55), 5, jewelPaint);
    canvas.drawCircle(Offset(left + w * 0.8, topY - h * 0.55), 5, jewelPaint);
  }

  void _drawSunglasses(Canvas canvas, double cx, double eyeY, double width, Paint paint, Paint stroke) {
    final double w = width * 0.85;
    final double h = w * 0.35;
    final double left = cx - w / 2;

    final RRect leftLens = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, eyeY, w * 0.44, h),
      const Radius.circular(12),
    );
    final RRect rightLens = RRect.fromRectAndRadius(
      Rect.fromLTWH(left + w * 0.56, eyeY, w * 0.44, h),
      const Radius.circular(12),
    );

    // Black Glossy Gradient
    paint.shader = const LinearGradient(
      colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
    ).createShader(Rect.fromLTWH(left, eyeY, w, h));

    canvas.drawRRect(leftLens, paint);
    canvas.drawRRect(rightLens, paint);
    canvas.drawRRect(leftLens, stroke);
    canvas.drawRRect(rightLens, stroke);

    // Bridge Line
    canvas.drawLine(Offset(left + w * 0.44, eyeY + h * 0.3), Offset(left + w * 0.56, eyeY + h * 0.3), stroke);

    // Glass Reflection Accent
    final reflectPaint = Paint()..color = Colors.white30;
    canvas.drawLine(Offset(left + 8, eyeY + 6), Offset(left + w * 0.25, eyeY + h - 6), reflectPaint);
    canvas.drawLine(Offset(left + w * 0.56 + 8, eyeY + 6), Offset(left + w * 0.8, eyeY + h - 6), reflectPaint);
  }

  void _drawBunnyEars(Canvas canvas, double cx, double headY, double width, Paint paint, Paint stroke) {
    final double earW = width * 0.28;
    final double earH = width * 0.8;

    final Paint outerPaint = Paint()..color = Colors.white;
    final Paint innerPaint = Paint()..color = const Color(0xFFFBCFE8);

    // Left Ear
    final Path leftEar = Path()
      ..addOval(Rect.fromLTWH(cx - earW * 1.5, headY - earH, earW, earH));
    final Path leftInner = Path()
      ..addOval(Rect.fromLTWH(cx - earW * 1.35, headY - earH * 0.85, earW * 0.7, earH * 0.75));

    // Right Ear
    final Path rightEar = Path()
      ..addOval(Rect.fromLTWH(cx + earW * 0.5, headY - earH, earW, earH));
    final Path rightInner = Path()
      ..addOval(Rect.fromLTWH(cx + earW * 0.65, headY - earH * 0.85, earW * 0.7, earH * 0.75));

    canvas.drawPath(leftEar, outerPaint);
    canvas.drawPath(leftEar, stroke);
    canvas.drawPath(leftInner, innerPaint);

    canvas.drawPath(rightEar, outerPaint);
    canvas.drawPath(rightEar, stroke);
    canvas.drawPath(rightInner, innerPaint);
  }

  void _drawDevilHorns(Canvas canvas, double cx, double headY, double width, Paint paint, Paint stroke) {
    final double hornH = width * 0.45;

    final Paint hornPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFEF4444), Color(0xFF991B1B)],
      ).createShader(Rect.fromLTWH(cx - width / 2, headY - hornH, width, hornH));

    // Left Horn
    final Path leftHorn = Path()
      ..moveTo(cx - width * 0.35, headY)
      ..quadraticBezierTo(cx - width * 0.45, headY - hornH * 0.6, cx - width * 0.25, headY - hornH)
      ..quadraticBezierTo(cx - width * 0.2, headY - hornH * 0.4, cx - width * 0.15, headY)
      ..close();

    // Right Horn
    final Path rightHorn = Path()
      ..moveTo(cx + width * 0.15, headY)
      ..quadraticBezierTo(cx + width * 0.2, headY - hornH * 0.4, cx + width * 0.25, headY - hornH)
      ..quadraticBezierTo(cx + width * 0.45, headY - hornH * 0.6, cx + width * 0.35, headY)
      ..close();

    canvas.drawPath(leftHorn, hornPaint);
    canvas.drawPath(leftHorn, stroke);

    canvas.drawPath(rightHorn, hornPaint);
    canvas.drawPath(rightHorn, stroke);
  }

  void _drawFloatingHearts(Canvas canvas, Size size, double cx, double cy, double width) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final List<Offset> offsets = [
      Offset(cx - width * 0.8, cy - width * 0.4),
      Offset(cx + width * 0.7, cy - width * 0.5),
      Offset(cx - width * 0.6, cy + width * 0.5),
      Offset(cx + width * 0.6, cy + width * 0.4),
    ];

    for (final offset in offsets) {
      textPainter.text = const TextSpan(text: '❤️', style: TextStyle(fontSize: 36));
      textPainter.layout();
      textPainter.paint(canvas, offset);
    }
  }

  void _drawFireAura(Canvas canvas, double cx, double cy, double width, Paint paint) {
    final auraPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20)
      ..color = const Color(0xFFF97316).withOpacity(0.6);

    canvas.drawCircle(Offset(cx, cy), width * 0.85, auraPaint);
  }

  @override
  bool shouldRepaint(covariant ARStickerPainter oldDelegate) {
    return oldDelegate.activeEffectId != activeEffectId || oldDelegate.animationProgress != animationProgress;
  }
}

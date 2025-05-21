import 'dart:math';
import 'package:flutter/material.dart';
import 'star_model.dart';

class StarryBackgroundPainter extends CustomPainter {
  final List<Star> stars;
  final Animation<double> animation;

  StarryBackgroundPainter(this.stars, this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final time = animation.value * 2 * pi;
    for (var star in stars) {
      final offsetX = sin(time * star.horizontalFrequency) * star.horizontalAmplitude;
      final offsetY = cos(time * star.verticalFrequency) * star.verticalAmplitude;
      final pulse = 1.0 + 0.3 * sin(time + star.pulseFactor);
      final center = Offset(
        star.x * size.width + offsetX,
        star.y * size.height + offsetY,
      );

      final gradient = RadialGradient(
        colors: [
          star.color.withAlpha((star.opacity * 255).round()),
          star.color.withAlpha(0),
        ],
        stops: [0.2, 1.0],
      );
      final rect = Rect.fromCircle(center: center, radius: star.initialRadius * pulse);

      final paint = Paint()..shader = gradient.createShader(rect);
      canvas.drawCircle(center, star.initialRadius * pulse, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class NebulaBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    const gradient = LinearGradient(
      colors: [
        Color(0x400F2027),
        Color(0x40203A43),
        Color(0x402C5364),
        Color(0x402C3E50),
        Color(0x40FF4500),
        Color(0x40000000),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
    );

    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

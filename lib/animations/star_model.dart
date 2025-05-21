import 'dart:math';
import 'package:flutter/material.dart';

class Star {
  late double x, y, radius, pulseFactor, initialRadius;
  late double horizontalAmplitude, verticalAmplitude;
  late double horizontalFrequency, verticalFrequency;
  late double opacity;
  late Color color;

  Star() {
    final random = Random();
    x = random.nextDouble();
    y = random.nextDouble();
    initialRadius = random.nextDouble() * 1.5 + 0.5;
    radius = initialRadius;
    pulseFactor = random.nextDouble() * 2 * pi;

    horizontalAmplitude = random.nextDouble() * 2 + 2;
    verticalAmplitude = random.nextDouble() * 1.5 + 1;
    horizontalFrequency = random.nextDouble() * 0.5 + 1.5;
    verticalFrequency = random.nextDouble() * 1 + 0.5;
    opacity = random.nextDouble() * 0.5 + 0.5;
    color = _getRandomStarColor(random);
  }

  Color _getRandomStarColor(Random random) {
    final colors = [
      Colors.blue,
      const Color(0xFF7EC0EE),
      const Color(0xFFADD8E6),
      Colors.white,
      const Color(0xFFFFFACD),
      const Color(0xFFFFDAB9),
      const Color(0xFFFFA07A),
    ];
    return colors[random.nextInt(colors.length)];
  }
}

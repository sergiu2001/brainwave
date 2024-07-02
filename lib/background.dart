import 'package:flutter/material.dart';
import 'dart:math';

class StarryBackgroundWidget extends StatefulWidget {
  final Widget child;

  const StarryBackgroundWidget({Key? key, required this.child}) : super(key: key);

  @override
  _StarryBackgroundWidgetState createState() => _StarryBackgroundWidgetState();
}

class _StarryBackgroundWidgetState extends State<StarryBackgroundWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Star> _stars = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    for (int i = 0; i < 200; i++) {
      _stars.add(Star());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: NebulaBackgroundPainter(),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: Size.infinite,
              painter: StarryBackgroundPainter(_stars, _controller),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

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

    horizontalAmplitude = random.nextDouble() * 4 + 2;
    verticalAmplitude = random.nextDouble() * 3 + 1;
    horizontalFrequency = random.nextDouble() * 1 + 1.5;
    verticalFrequency = random.nextDouble() * 1 + 1;
    opacity = random.nextDouble() * 0.5 + 0.5;
    color = _getRandomStarColor(random);
  }

  Color _getRandomStarColor(Random random) {
    final colors = [
      Colors.blue,
      Color(0xFF7EC0EE),
      Color(0xFFADD8E6),
      Colors.white,
      Color(0xFFFFFACD),
      Color(0xFFFFDAB9),
      Color(0xFFFFA07A),
    ];
    return colors[random.nextInt(colors.length)];
  }
}

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
      final center = Offset(star.x * size.width + offsetX, star.y * size.height + offsetY);
      final gradient = RadialGradient(
        colors: [
          star.color.withOpacity(star.opacity),
          star.color.withOpacity(0),
        ],
        stops: [0.2, 1.0],
      );
      final rect = Rect.fromCircle(center: center, radius: star.initialRadius * pulse);

      final paint = Paint()
        ..shader = gradient.createShader(rect);

      canvas.drawCircle(center, star.initialRadius * pulse, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class NebulaBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      colors: [
        Color(0x400F2027), // Dark blue-black with more transparency
        Color(0x40203A43), // Dark teal with more transparency
        Color(0x402C5364), // Darker teal with more transparency
        Color(0x402C3E50), // Darker blue-black with more transparency
        Color(0x40FF4500), // Red-orange with more transparency
        Color(0x40000000), // Black with more transparency
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..blendMode = BlendMode.srcOver;

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

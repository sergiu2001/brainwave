import 'package:flutter/material.dart';
import 'star_painter.dart';
import 'star_model.dart';

class StarryBackgroundWidget extends StatefulWidget {
  final Widget child;

  const StarryBackgroundWidget({super.key, required this.child});

  @override
  State<StarryBackgroundWidget> createState() => _StarryBackgroundWidgetState();
}

class _StarryBackgroundWidgetState extends State<StarryBackgroundWidget>
    with SingleTickerProviderStateMixin {
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
        // Painted nebula background
        Positioned.fill(
          child: CustomPaint(
            painter: NebulaBackgroundPainter(),
          ),
        ),
        // Animated star painter
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: Size.infinite,
              painter: StarryBackgroundPainter(_stars, _controller),
            );
          },
        ),
        // Child widget on top
        widget.child,
      ],
    );
  }
}

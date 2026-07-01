import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedRainbowLine extends StatefulWidget {
  const AnimatedRainbowLine({super.key});

  @override
  State<AnimatedRainbowLine> createState() => _AnimatedRainbowLineState();
}

class _AnimatedRainbowLineState extends State<AnimatedRainbowLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getRandomColor() {
    return Color.fromRGBO(
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
      1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: LinearGradient(
              colors: [
                _getRandomColor(),
                _getRandomColor(),
                _getRandomColor(),
                _getRandomColor(),
                _getRandomColor(),
              ],
              stops: [
                0.0,
                0.25,
                0.5,
                0.75,
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }
}

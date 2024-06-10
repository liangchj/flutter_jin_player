import 'package:flutter/material.dart';

class MySliderThumbShape extends SliderComponentShape {
  const MySliderThumbShape(
      {this.thumbRadius = 8.0,
      this.thumbColor = Colors.white,
      this.thumbInnerRadius = 3.0,
      this.thumbInnerColor = const Color(0xFF836BFF)});

  final double thumbRadius;
  final Color thumbColor;
  final double thumbInnerRadius;
  final Color thumbInnerColor;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    Paint paint = Paint();
    canvas.drawCircle(
      center,
      thumbRadius,
      paint
        ..style = PaintingStyle.fill
        ..color = thumbColor,
    );
    canvas.drawCircle(
      center,
      thumbRadius,
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = const Color(0x1A836BFE),
    );
    canvas.drawCircle(
      center,
      thumbInnerRadius,
      paint
        ..style = PaintingStyle.fill
        ..color = thumbInnerColor,
    );
  }
}

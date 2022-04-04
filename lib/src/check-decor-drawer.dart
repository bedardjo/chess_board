import 'package:flutter/material.dart';

class CheckDecorDrawer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..shader = RadialGradient(colors: [
        Colors.red.withOpacity(0),
        Colors.red.withOpacity(0),
        Colors.red.withOpacity(.7),
        Colors.red.withOpacity(0)
      ], stops: const [
        0,
        .5,
        .61,
        .95
      ]).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawCircle(
        Offset(size.width * .5, size.height * .5), size.width * .5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

import 'package:flutter/material.dart';

class PossibleCaptureDrawer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * .25, 0)
      ..lineTo(0, size.height * .25)
      ..close()
      ..moveTo(size.width * .75, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * .25)
      ..close()
      ..moveTo(size.width, size.height * .75)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * .75, size.height)
      ..close()
      ..moveTo(0, size.height * .75)
      ..lineTo(size.width * .25, size.height)
      ..lineTo(0, size.height)
      ..close();
    Paint paint = Paint()..color = Colors.red.withOpacity(.5);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

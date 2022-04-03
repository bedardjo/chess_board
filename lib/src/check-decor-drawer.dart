import 'package:flutter/material.dart';

class CheckDecorDrawer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path()
      ..moveTo(size.width * .7, size.height * .7)
      ..lineTo(size.width * .85, size.height * .85)
      ..close()
      ..moveTo(size.width * .3, size.height * .3)
      ..lineTo(size.width * .15, size.height * .15)
      ..close()
      ..moveTo(size.width * .3, size.height * .7)
      ..lineTo(size.width * .15, size.height * .85)
      ..close()
      ..moveTo(size.width * .7, size.height * .3)
      ..lineTo(size.width * .85, size.height * .15)
      ..close();
    Paint paint = Paint()
      ..color = Colors.red.withOpacity(.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawPath(path, paint);
    canvas.drawCircle(
        Offset(size.width * .5, size.height * .5), size.width * .4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

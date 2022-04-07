import 'dart:math';

import 'package:flutter/material.dart';

import 'arrow.dart';

class DecorLayer extends StatefulWidget {
  final List<Arrow> arrows;

  const DecorLayer({Key? key, required this.arrows}) : super(key: key);
  @override
  State<StatefulWidget> createState() => DecorLayerState();
}

class DecorLayerState extends State<DecorLayer> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: DecorPainter(arrows: widget.arrows));
  }
}

Color _arrowColor = const Color.fromARGB(255, 71, 104, 149);

class DecorPainter extends CustomPainter {
  final List<Arrow> arrows;

  DecorPainter({required this.arrows});

  @override
  void paint(Canvas canvas, Size size) {
    double arrowHeadWidth = size.width / 20.0;
    double arrowWidth = size.width / 70.0;
    Paint arrowPaint = Paint()
      ..color = _arrowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 30.0;
    Paint arrowHeadPaint = Paint()
      ..color = _arrowColor
      ..style = PaintingStyle.fill;
    for (Arrow arrow in arrows) {
      Offset start = Offset(((arrow.start.x + .5) / 8.0) * size.width,
          (1.0 - (arrow.start.y + .5) / 8.0) * size.height);
      Offset end = Offset(((arrow.end.x + .5) / 8.0) * size.width,
          (1.0 - (arrow.end.y + .5) / 8.0) * size.height);
      double arrowDirection = (end - start).direction;
      end = Offset(end.dx - cos(arrowDirection) * arrowHeadWidth,
          end.dy - sin(arrowDirection) * arrowHeadWidth);
      arrowPaint.color = _arrowColor.withOpacity(arrow.opacity);
      arrowHeadPaint.color = _arrowColor.withOpacity(arrow.opacity);

      Point<double> arrowLeft =
          Point(cos(arrowDirection + pi * .5), sin(arrowDirection + pi * .5));
      Point<double> arrowRight =
          Point(cos(arrowDirection - pi * .5), sin(arrowDirection - pi * .5));
      Point<double> arrowHeadStartLeft = Point(
          end.dx - cos(arrowDirection) * arrowWidth + arrowLeft.x * arrowWidth,
          end.dy - sin(arrowDirection) * arrowWidth + arrowLeft.y * arrowWidth);
      canvas.drawPath(
          Path()
            ..moveTo(start.dx + arrowLeft.x * arrowWidth,
                start.dy + arrowLeft.y * arrowWidth)
            ..lineTo(arrowHeadStartLeft.x, arrowHeadStartLeft.y)
            ..lineTo(
                end.dx -
                    cos(arrowDirection) * arrowWidth +
                    arrowLeft.x * arrowHeadWidth,
                end.dy -
                    sin(arrowDirection) * arrowWidth +
                    arrowLeft.y * arrowHeadWidth)
            ..lineTo(end.dx + cos(arrowDirection) * arrowHeadWidth,
                end.dy + sin(arrowDirection) * arrowHeadWidth)
            ..lineTo(
                end.dx -
                    cos(arrowDirection) * arrowWidth +
                    arrowRight.x * arrowHeadWidth,
                end.dy -
                    sin(arrowDirection) * arrowWidth +
                    arrowRight.y * arrowHeadWidth)
            ..lineTo(
                end.dx -
                    cos(arrowDirection) * arrowWidth +
                    arrowRight.x * arrowWidth,
                end.dy -
                    sin(arrowDirection) * arrowWidth +
                    arrowRight.y * arrowWidth)
            ..lineTo(start.dx + arrowRight.x * arrowWidth,
                start.dy + arrowRight.y * arrowWidth),
          arrowHeadPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackgroundDrawing extends CustomPainter {
  final BuildContext context;

  BackgroundDrawing(this.context);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Theme.of(context).primaryColor;
    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height * 0.33)
      ..quadraticBezierTo(size.width * 0.85, size.height * 0.37, size.width, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

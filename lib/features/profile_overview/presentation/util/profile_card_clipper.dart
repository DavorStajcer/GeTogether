import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileCardClipper extends CustomClipper<Path> {
  final double picHeight;

  ProfileCardClipper({required this.picHeight});

  @override
  Path getClip(Size size) {
    final picRadius = picHeight / 2;
    /*  return Path()
      ..moveTo(0, picRadius + picRadius)
      ..quadraticBezierTo(5, picRadius, size.width / 2 - picRadius, picRadius)
      ..moveTo(size.width / 2 - picRadius, picRadius)
      ..lineTo(size.width / 2 + picRadius, picRadius)
      ..quadraticBezierTo(
          size.width - 5, picRadius, size.width, picRadius + picRadius)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, picRadius + picRadius)
      ..close(); */
    return Path()
      ..moveTo(0, picRadius)
      ..lineTo(size.width, picRadius)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class ProfileCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint dacaPaint = Paint()..color = Colors.blue;
    Path dacaPath = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(dacaPath, dacaPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

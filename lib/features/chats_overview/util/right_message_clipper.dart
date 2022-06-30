import 'package:flutter/cupertino.dart';

class RightMessageClipper extends CustomClipper<Path> {
  final double rightPadding;

  RightMessageClipper(this.rightPadding);
  @override
  Path getClip(Size size) {
    final double arcSide = 20;
    final double tailHeight = 20;
    final double tailWidth = tailHeight;
    return Path()
      ..moveTo(0, arcSide)
      ..quadraticBezierTo(0, 0, arcSide, 0)
      ..lineTo(size.width - arcSide - rightPadding, 0)
      ..quadraticBezierTo(
          size.width - rightPadding, 0, size.width - rightPadding, arcSide)
      ..lineTo(
          size.width - rightPadding, size.height - tailHeight - rightPadding)
      ..quadraticBezierTo(size.width - rightPadding, size.height - rightPadding,
          size.width - rightPadding / 3, size.height - rightPadding / 3)
      ..quadraticBezierTo(size.width - rightPadding, size.height - rightPadding,
          size.width - rightPadding - tailWidth, size.height - rightPadding)
      ..lineTo(arcSide, size.height - rightPadding)
      ..quadraticBezierTo(0, size.height - rightPadding, 0,
          size.height - rightPadding - arcSide)
      ..lineTo(0, arcSide);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

import 'package:flutter/cupertino.dart';

class LeftMessageClipper extends CustomClipper<Path> {
  final double leftPadding;

  LeftMessageClipper(this.leftPadding);
  @override
  Path getClip(Size size) {
    final double arcSide = 20;
    final double tailHeight = 20;
    final double tailWidth = tailHeight;
    return Path()
      ..moveTo(leftPadding, arcSide)
      ..quadraticBezierTo(leftPadding, 0, leftPadding + arcSide, 0)
      ..lineTo(size.width - arcSide, 0)
      ..quadraticBezierTo(size.width, 0, size.width, arcSide)
      ..lineTo(size.width, size.height - arcSide - leftPadding)
      ..quadraticBezierTo(size.width, size.height - leftPadding,
          size.width - arcSide, size.height - leftPadding)
      ..lineTo(leftPadding + tailWidth, size.height - leftPadding)
      ..quadraticBezierTo(
          leftPadding, size.height - leftPadding, leftPadding / 3, size.height)
      ..quadraticBezierTo(leftPadding, size.height - leftPadding, leftPadding,
          size.height - leftPadding - tailHeight)
      ..lineTo(leftPadding, arcSide);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

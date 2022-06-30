import 'package:flutter/cupertino.dart';

class AdminImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double cutHorizontalPadding = size.width * 0.25;
    return Path()
      ..moveTo(0 + cutHorizontalPadding, 20)
      ..quadraticBezierTo(
          0 + cutHorizontalPadding, 0, 20 + cutHorizontalPadding, 0)
      ..lineTo(size.width - 20 - cutHorizontalPadding, 0)
      ..quadraticBezierTo(size.width - cutHorizontalPadding, 0,
          size.width - cutHorizontalPadding, 20)
      ..lineTo(size.width - cutHorizontalPadding, size.height - 20)
      ..quadraticBezierTo(size.width - cutHorizontalPadding, size.height,
          size.width - 20 - cutHorizontalPadding, size.height)
      ..lineTo(20 + cutHorizontalPadding, size.height)
      ..quadraticBezierTo(cutHorizontalPadding, size.height,
          cutHorizontalPadding, size.height - 20)
      ..lineTo(cutHorizontalPadding, 20)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

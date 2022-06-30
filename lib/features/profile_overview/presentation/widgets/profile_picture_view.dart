import 'package:flutter/material.dart';

class ProfilePictureView extends StatelessWidget {
  final double picHeight;
  final String imageUrl;
  const ProfilePictureView(
      {Key? key, required this.picHeight, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: picHeight,
      height: picHeight,
      padding: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 1,
          color: Colors.black12,
        ),
        image: DecorationImage(
          fit: BoxFit.fitWidth,
          image: NetworkImage(imageUrl),
        ),
        color: Colors.grey,
      ),
    );
  }
}

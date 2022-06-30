import 'package:flutter/material.dart';

class GetTogetherTitle extends StatelessWidget {
  final Color textColor;
  const GetTogetherTitle({Key? key, required this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(top: 15),
        child: Text(
          "GeTogether",
          style: TextStyle(
              color: textColor, fontSize: 35, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

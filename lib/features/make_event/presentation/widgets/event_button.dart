import 'package:flutter/material.dart';

class EventButton extends StatelessWidget {
  final String text;
  final bool isOn;
  final Function() navigate;
  final Color? buttonColor;
  final Color? textColor;
  EventButton({
    Key? key,
    required this.text,
    required this.navigate,
    bool? isOn,
    this.buttonColor,
    this.textColor,
  })  : isOn = isOn ?? true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Theme.of(context).primaryColor.withOpacity(0.6),
        ),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40), side: BorderSide.none),
        ),
        backgroundColor: MaterialStateProperty.all(
          buttonColor ?? Colors.white,
        ),
        elevation: MaterialStateProperty.all(0),
        overlayColor: MaterialStateProperty.resolveWith(
          (states) {
            return states.contains(MaterialState.pressed)
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : null;
          },
        ),
      ),
      onPressed: isOn == false
          ? null
          : () {
              navigate();
            },
    );
  }
}

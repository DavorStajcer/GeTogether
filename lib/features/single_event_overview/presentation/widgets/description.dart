import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  final String _description;
  const Description(this._description, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 2,
          child: Container(
            alignment: Alignment.topLeft,
            child: Text(
              "Decription",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 5,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Flexible(
                flex: 13,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Text(_description),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

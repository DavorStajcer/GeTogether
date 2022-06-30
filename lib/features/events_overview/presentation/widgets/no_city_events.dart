import 'package:flutter/material.dart';

class NoCityEvents extends StatelessWidget {
  const NoCityEvents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No events for your city. Make the first step and create one !",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          Icon(
            Icons.camera_front_outlined,
            size: 100,
          ),
        ],
      ),
    );
  }
}

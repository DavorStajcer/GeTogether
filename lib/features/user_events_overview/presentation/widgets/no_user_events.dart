import 'package:flutter/material.dart';

class NoUserEvents extends StatelessWidget {
  const NoUserEvents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You are currently participating in zero events. Join some or create them yourself !",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          Image.asset("lib/assets/images/no_events.png"),
        ],
      ),
    );
  }
}

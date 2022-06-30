import 'package:flutter/material.dart';

class NoNotifications extends StatelessWidget {
  const NoNotifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No notifications yet. Join some events to get some.",
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
            Icons.notification_important_outlined,
            size: 70,
          ),
        ],
      ),
    );
  }
}

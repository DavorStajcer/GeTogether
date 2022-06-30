import 'package:flutter/material.dart';

class NoChats extends StatelessWidget {
  const NoChats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No chats yet. Join some events to get some.",
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
            Icons.chat,
            size: 70,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class NameAndMessage extends StatelessWidget {
  final String name;
  final String messageSnippet;
  final bool isUnread;
  const NameAndMessage({
    required this.name,
    required this.messageSnippet,
    required this.isUnread,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                  fontSize: isUnread ? 16 : 15,
                  color: isUnread ? Colors.black : Colors.black38,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 7, bottom: 15),
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.centerLeft,
                child: Text(
                  messageSnippet,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color.fromRGBO(161, 160, 160, 1),
                    fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                    fontSize: isUnread ? 15 : 13,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

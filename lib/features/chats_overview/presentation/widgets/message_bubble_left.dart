import "package:flutter/material.dart";
import 'package:get_together_app/features/chats_overview/domain/enitites/message.dart';
import 'package:get_together_app/features/chats_overview/util/left_message_clipper.dart';
import 'package:intl/intl.dart';

class MessageBubbleLeft extends StatelessWidget {
  final Message message;
  const MessageBubbleLeft(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            flex: 2,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 30, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        message.date == null
                            ? " "
                            : DateFormat.Hms().format(message.date!),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 9,
                        ),
                      ),
                      Text(
                        message.username,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                ClipPath(
                  clipper: LeftMessageClipper(20),
                  child: Container(
                    color: Theme.of(context).primaryColor.withOpacity(0.8),
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        left: 30, bottom: 30, top: 10, right: 10),
                    child: Text(
                      message.content,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )),
        Flexible(
          flex: 2,
          child: Container(
            width: double.infinity,
          ),
        ),
      ],
    );
  }
}

/* 

 */

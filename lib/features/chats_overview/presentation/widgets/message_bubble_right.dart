import "package:flutter/material.dart";
import 'package:get_together_app/features/chats_overview/domain/enitites/message.dart';
import 'package:get_together_app/features/chats_overview/util/right_message_clipper.dart';
import 'package:intl/intl.dart';

class MessageBubbleRight extends StatelessWidget {
  final Message message;
  const MessageBubbleRight(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Container(),
        ),
        Flexible(
          flex: 2,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(right: 30, left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      message.username,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      message.date == null
                          ? " "
                          : DateFormat.Hms().format(message.date!),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
              ClipPath(
                clipper: RightMessageClipper(20),
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding:
                      EdgeInsets.only(bottom: 30, right: 30, top: 10, left: 10),
                  child: Text(
                    message.content,
                    style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).primaryColor.withOpacity(1)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

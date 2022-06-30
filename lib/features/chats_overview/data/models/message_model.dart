import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_together_app/features/chats_overview/domain/enitites/message.dart';
import 'package:get_together_app/features/chats_overview/presentation/widgets/chat_messages.dart';

class MessageModel extends Message {
  MessageModel({
    // required String userId,
    required String username,
    required String userImageUrl,
    required String content,
    DateTime? date,
    required Sender sender,
  }) : super(
          // userId: userId,
          username: username,
          userImageUrl: userImageUrl,
          content: content,
          date: date,
          sender: sender,
        );

  factory MessageModel.fromJsonMap(
          //String userId,
          Sender sender,
          Map<String, dynamic> json) =>
      MessageModel(
        //
        //  userId: userId,
        username: json["username"],
        userImageUrl: json["userImageUrl"],
        content: json["content"],
        date: json["timestamp"] == null
            ? json["timestamp"]
            : (json["timestamp"] as Timestamp).toDate(),
        sender: sender,
      );

  Map<String, dynamic> toJsonMap(String senderId, String eventCity) => {
        "senderId": senderId,
        "username": username,
        "userImageUrl": userImageUrl,
        "eventCity": eventCity,
        "content": content,
        "timestamp": FieldValue.serverTimestamp(),
      };
}

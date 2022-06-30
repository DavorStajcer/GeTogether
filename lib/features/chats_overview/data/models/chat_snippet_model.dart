import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_together_app/features/chats_overview/domain/enitites/chat_snippet.dart';

class ChatSnippetModel extends ChatSnippet {
  ChatSnippetModel({
    required String eventId,
    required String eventName,
    required String adminImageUrl,
    required String eventCity,
    required bool isUnread,
    required DateTime? lastMessageDate,
    required DateTime? chatCreation,
    required final String? lastMessageSnippet,
  }) : super(
            eventId: eventId,
            eventName: eventName,
            adminImageUrl: adminImageUrl,
            eventCity: eventCity,
            isUnread: isUnread,
            chatCreation: chatCreation,
            lastMessageDate: lastMessageDate,
            lastMessageSnippet: lastMessageSnippet);

  factory ChatSnippetModel.fromJsonMap({
    required String eventId,
    required bool isUnread,
    required Map<String, dynamic> json,
  }) =>
      ChatSnippetModel(
        eventId: eventId,
        eventName: json["eventName"],
        eventCity: json["eventCity"],
        //  isUnread: json["isUnread"] == null ? false : json["isUnread"],
        isUnread: isUnread,
        chatCreation: json["createDate"] != null
            ? (json["createDate"] as Timestamp).toDate()
            : null,
        adminImageUrl: json["adminImageUrl"],
        lastMessageDate: json["lastMessageDate"] != null
            ? (json["lastMessageDate"] as Timestamp).toDate()
            : null,
        lastMessageSnippet: json["lastMessageSnippet"],
      );

  Map<String, dynamic> toJsonMap() => {
        "eventName": this.eventName,
        "eventCity": this.eventCity,
        "adminImageUrl": this.adminImageUrl,
        "lastMessageDate": lastMessageDate,
        "chatCreation": FieldValue.serverTimestamp(),
        "lastMessageSnippet": this.lastMessageSnippet,
      };
}

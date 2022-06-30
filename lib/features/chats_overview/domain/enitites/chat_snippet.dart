import 'package:equatable/equatable.dart';

class ChatSnippet extends Equatable {
  final String eventId;
  final String eventName;
  final String eventCity;
  final String adminImageUrl;
  final bool isUnread;
  final DateTime? lastMessageDate;
  final DateTime? chatCreation;
  final String? lastMessageSnippet;
  String get sentBeforeString {
    if (lastMessageDate == null) {
      return ".s";
    }
    final secondsFormLastMessage =
        DateTime.now().difference(lastMessageDate!).inSeconds;
    double fakeMinutes = secondsFormLastMessage / 60;
    final hours = fakeMinutes / 60;
    final minutes = fakeMinutes % 60;
    final seconds = secondsFormLastMessage % 60;

    return hours >= 1
        ? "${hours.toStringAsFixed(0)}h"
        : minutes >= 1
            ? "${minutes.toStringAsFixed(0)}m"
            : "${seconds}s";
  }

  ChatSnippet({
    required this.eventId,
    required this.eventName,
    required this.adminImageUrl,
    required this.eventCity,
    required this.isUnread,
    this.lastMessageDate,
    this.chatCreation,
    required this.lastMessageSnippet,
  });

  @override
  List<Object?> get props => [
        eventId,
        eventName,
        adminImageUrl,
        lastMessageDate,
        lastMessageSnippet,
        chatCreation,
        isUnread,
        eventCity,
      ];
}

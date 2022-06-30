import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_together_app/features/notifications_overview/domain/entities/notification.dart';
import 'package:get_together_app/features/notifications_overview/presentation/widgets/join_request.dart';

class EventInfoNotificationModel extends EventInfoNotification {
  final String? notificationId;
  EventInfoNotificationModel({
    required String content,
    DateTime? date,
    this.notificationId,
  }) : super(
          content: content,
          date: date,
        );

  factory EventInfoNotificationModel.fromJsonMap(Map<String, dynamic> json) =>
      EventInfoNotificationModel(
        content: json["content"],
        date: json["timestamp"] == null
            ? json["timestamp"]
            : (json["timestamp"] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJsonMap(FieldValue serverTimestamp) => {
        "type": NotificationType.event_info.index,
        "content": this.content,
        "timestamp": serverTimestamp,
      };
}

class LeaveEventInfoNotificationModel extends LeaveEventInfoNotification {
  LeaveEventInfoNotificationModel({
    required String content,
    required String senderImageUrl,
    DateTime? date,
  }) : super(
          content: content,
          date: date,
          senderImageUrl: senderImageUrl,
        );

  factory LeaveEventInfoNotificationModel.fromJsonMap(
          Map<String, dynamic> json) =>
      LeaveEventInfoNotificationModel(
        content: json["content"],
        date: json["timestamp"] == null
            ? json["timestamp"]
            : (json["timestamp"] as Timestamp).toDate(),
        senderImageUrl: json["senderImageUrl"],
      );

  Map<String, dynamic> toJsonMap(FieldValue serverTimestamp) => {
        "type": NotificationType.leave.index,
        "content": this.content,
        "timestamp": serverTimestamp,
        "senderImageUrl": this.senderImageUrl,
      };
}

class JoinEventNotificationModel extends JoinEventNotification {
  final String? notificationId;
  JoinEventNotificationModel({
    required String senderId,
    required String senderImageUrl,
    required String eventId,
    required String city,
    required String content,
    required String eventName,
    required NotificationResolved resolvedStatus,
    DateTime? date,
    this.notificationId,
  }) : super(
            senderId: senderId,
            eventId: eventId,
            eventName: eventName,
            senderImageUrl: senderImageUrl,
            content: content,
            eventCity: city,
            resolvedStatus: resolvedStatus,
            date: date);

  factory JoinEventNotificationModel.fromJsonMap(
          String notificationId, Map<String, dynamic> json) =>
      JoinEventNotificationModel(
        senderId: json["senderId"],
        senderImageUrl: json["senderImageUrl"],
        eventId: json["eventId"],
        content: json["content"],
        eventName: json["eventName"],
        city: json["city"],
        resolvedStatus: _mapIndexToResolvedStatus(json["resolvedStatus"]),
        notificationId: notificationId,
        date: json["timestamp"] == null
            ? json["timestamp"]
            : (json["timestamp"] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJsonMap(
          NotificationType notificationType, FieldValue serverTimestamp) =>
      {
        "type": notificationType.index,
        "senderId": senderId,
        "senderImageUrl": this.senderImageUrl,
        "eventId": this.eventId,
        "eventName": this.eventName,
        "content": this.content,
        "city": this.eventCity,
        "timestamp": serverTimestamp,
        "resolvedStatus": resolvedStatus.index,
      };
}

NotificationResolved _mapIndexToResolvedStatus(int index) {
  switch (index) {
    case 0:
      return NotificationResolved.pending;
    case 1:
      return NotificationResolved.accepted;
    case 2:
      return NotificationResolved.rejected;

    default:
      return NotificationResolved.rejected;
  }
}

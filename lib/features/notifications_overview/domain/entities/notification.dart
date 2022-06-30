import 'package:equatable/equatable.dart';
import 'package:get_together_app/features/notifications_overview/presentation/widgets/join_request.dart';

enum NotificationType { event_info, join, leave }

class EventInfoNotification extends Equatable {
  final String content;
  final DateTime? date;

  EventInfoNotification({
    required this.content,
    this.date,
  });

  @override
  List<Object?> get props => [content, date];
}

class LeaveEventInfoNotification extends EventInfoNotification {
  final String senderImageUrl;

  LeaveEventInfoNotification({
    required this.senderImageUrl,
    required String content,
    required DateTime? date,
  }) : super(
          content: content,
          date: date,
        );

  @override
  List<Object?> get props => [senderImageUrl, content, date];
}

class JoinEventNotification extends LeaveEventInfoNotification {
  final NotificationResolved resolvedStatus;
  final String eventId;
  final String senderId;
  final String eventCity;
  final String eventName;

  JoinEventNotification({
    required this.eventCity,
    required this.senderId,
    required this.eventId,
    required this.eventName,
    required String senderImageUrl,
    required String content,
    DateTime? date,
    required this.resolvedStatus,
  }) : super(
          senderImageUrl: senderImageUrl,
          content: content,
          date: date,
        );

  @override
  List<Object?> get props => [
        senderId,
        eventCity,
        eventId,
        senderImageUrl,
        content,
        date,
        resolvedStatus
      ];
}

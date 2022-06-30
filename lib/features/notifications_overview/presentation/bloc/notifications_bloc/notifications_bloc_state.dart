import 'package:equatable/equatable.dart';
import 'package:get_together_app/features/notifications_overview/domain/entities/notification.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsLoading extends NotificationsState {}

abstract class NotificationsFailure extends NotificationsState {
  final String message;
  NotificationsFailure(this.message);

  @override
  List<Object> get props => [message];
}

class NotificationsServerFailure extends NotificationsFailure {
  NotificationsServerFailure(String message) : super(message);
}

class NotificationsNetworkFailure extends NotificationsFailure {
  NotificationsNetworkFailure(String message) : super(message);
}

class NotificationsLoaded extends NotificationsState {
  final List<EventInfoNotification> notifications;
  NotificationsLoaded(this.notifications);

  factory NotificationsLoaded.addOnLoadedNotifications(
      List<EventInfoNotification> loadedNotifications,
      List<EventInfoNotification> newNotifications) {
    final List<EventInfoNotification> combinedNotifications = [];
    combinedNotifications.addAll(loadedNotifications);
    combinedNotifications.addAll(newNotifications);
    return NotificationsLoaded(combinedNotifications);
  }

  @override
  List<Object> get props => [notifications];
}

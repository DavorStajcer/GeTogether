part of 'new_notifications_bloc.dart';

abstract class NewNotificationsEvent extends Equatable {
  const NewNotificationsEvent();

  @override
  List<Object> get props => [];
}

class HomeScreenOpened extends NewNotificationsEvent {}

class NewNotificationsClosing extends NewNotificationsEvent {}

class NewNotificationNumChanged extends NewNotificationsEvent {
  final num;
  NewNotificationNumChanged(this.num);
}

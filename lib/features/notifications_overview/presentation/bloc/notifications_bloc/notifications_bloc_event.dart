import 'package:equatable/equatable.dart';

abstract class NotificationsBlocEvent extends Equatable {
  const NotificationsBlocEvent();

  @override
  List<Object> get props => [];
}

class NotificationsScreenInitialized extends NotificationsBlocEvent {}

class NotificationScreenLeft extends NotificationsBlocEvent {}

class NotificationsScrolledToEnd extends NotificationsBlocEvent {}

part of 'new_notifications_bloc.dart';

abstract class NewNotificationsState extends Equatable {
  final int newNotificationsNum;
  const NewNotificationsState(this.newNotificationsNum);

  @override
  List<Object> get props => [newNotificationsNum];
}

class NewNotificationsInitial extends NewNotificationsState {
  NewNotificationsInitial() : super(0);
}

class NewNotificationsLoaded extends NewNotificationsState {
  NewNotificationsLoaded(int newNotificationsNum) : super(newNotificationsNum);
}

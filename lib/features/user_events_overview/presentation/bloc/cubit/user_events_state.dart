part of 'user_events_cubit.dart';

abstract class UserEventsState extends Equatable {
  const UserEventsState();

  @override
  List<Object> get props => [];
}

class UserEventsInitial extends UserEventsState {}

class UserEventsFailure extends UserEventsState {
  final String message;
  UserEventsFailure(this.message);

  @override
  List<Object> get props => [message];
}

class UserEventsNetworkFailure extends UserEventsFailure {
  UserEventsNetworkFailure(String message) : super(message);
}

class UserEventsServerFailure extends UserEventsFailure {
  UserEventsServerFailure(String message) : super(message);
}

class UserEventsLoaded extends UserEventsState {
  final List<Event> userAdminEvents;
  UserEventsLoaded(this.userAdminEvents);

  @override
  List<Object> get props => [userAdminEvents];
}

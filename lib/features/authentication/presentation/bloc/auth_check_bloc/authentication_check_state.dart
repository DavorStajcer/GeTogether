part of 'authentication_check_bloc.dart';

abstract class AuthenticationCheckState extends Equatable {
  const AuthenticationCheckState();

  @override
  List<Object> get props => [];
}

class AuthenticationCheckInitialState extends AuthenticationCheckState {}

class UserLoggedInState extends AuthenticationCheckState {
  UserLoggedInState();
}

class UserNotLoggedInState extends AuthenticationCheckState {
  UserNotLoggedInState();
}

class ServerErrorState extends AuthenticationCheckState {
  ServerErrorState();
}

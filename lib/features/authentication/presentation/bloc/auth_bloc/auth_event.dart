part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignOutEvent extends AuthEvent {}

class LogInEvent extends AuthEvent {
  final LogInParameters authParam;

  LogInEvent(this.authParam);

  @override
  List<Object> get props => [authParam];
}

class SignUpEvent extends AuthEvent {
  final SignUpParameters authParam;

  SignUpEvent(this.authParam);

  @override
  List<Object> get props => [authParam];
}

part of 'authentication_check_bloc.dart';

abstract class AuthenticationCheckEvent extends Equatable {
  const AuthenticationCheckEvent();

  @override
  List<Object> get props => [];
}

class ApplicationStarted extends AuthenticationCheckEvent {}

class AuthStateChanged extends AuthenticationCheckEvent {
  final Either<Failure, User?> response;

  AuthStateChanged(this.response);

  @override
  List<Object> get props => [response];
}

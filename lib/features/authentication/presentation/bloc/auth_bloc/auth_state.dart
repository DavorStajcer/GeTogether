part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccessfull extends AuthState {}

class AuthFailed extends AuthState {
  final String message;

  AuthFailed(this.message);
  @override
  List<Object> get props => [message];
}

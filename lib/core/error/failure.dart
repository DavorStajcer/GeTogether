import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  Failure(this.message);
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {
  ServerFailure({String? message})
      : super(message ?? "Oops. Something went wrong. Try that again.");
}

class CashFailure extends Failure {
  CashFailure({String? message})
      : super(message ?? "Error while cashing some data. Try again later.");
}

class ParsingFailure extends Failure {
  ParsingFailure({String? message})
      : super(message ?? "Error while getting the location. Try again later.");
}

class LocationFailure extends Failure {
  LocationFailure({String? message})
      : super(message ?? "Error while getting the location. Try again later.");
}

class NetworkFailure extends Failure {
  NetworkFailure({String? message})
      : super(message ?? "No connection. Check your internet.");
}

class AuthenticationFailure extends Failure {
  AuthenticationFailure({String? message})
      : super(
            message ?? "Error while trying to authenticate. Try again later.");
}

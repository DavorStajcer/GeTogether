import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failure.dart';

abstract class Usecase<T, P> {
  Future<Either<Failure, T>> call(P param);
}

class NoParameters extends Equatable {
  @override
  List<Object> get props => [];
}

class SendMessagePrameters extends Equatable {
  final String eventId;
  final String message;
  final String eventCity;
  SendMessagePrameters({
    required this.eventId,
    required this.message,
    required this.eventCity,
  });

  @override
  List<Object?> get props => [
        eventId,
        message,
        eventCity,
      ];
}

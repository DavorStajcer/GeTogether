part of 'event_answer_cubit.dart';

abstract class EventAnswerState extends Equatable {
  const EventAnswerState();

  @override
  List<Object> get props => [];
}

class EventAnswerInitial extends EventAnswerState {}

class EventAnswerLoading extends EventAnswerState {}

class EventAnswerFailure extends EventAnswerState {}

class EventAnswerAccepted extends EventAnswerState {}

class EventAnswerRejected extends EventAnswerState {}

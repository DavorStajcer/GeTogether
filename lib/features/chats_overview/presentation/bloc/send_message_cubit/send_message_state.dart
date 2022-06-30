part of 'send_message_cubit.dart';

abstract class SendMessageState extends Equatable {
  const SendMessageState();

  @override
  List<Object> get props => [];
}

class SendMessageNormal extends SendMessageState {}

class SendMessageFailure extends SendMessageState {
  final String message;
  SendMessageFailure(this.message);
}

part of 'chat_messages_bloc.dart';

abstract class ChatMessagesEvent extends Equatable {
  const ChatMessagesEvent();

  @override
  List<Object> get props => [];
}

class ChatMessagesScreenInitialized extends ChatMessagesEvent {
  final String eventId;
  ChatMessagesScreenInitialized(this.eventId);
}

class LeavingChatScreen extends ChatMessagesEvent {
  final String eventId;
  LeavingChatScreen(this.eventId);
}

class MessagesAdded extends ChatMessagesEvent {
  final Either<Failure, List<Message>> response;
  MessagesAdded(this.response);

  @override
  List<Object> get props => [response];
}

class MessagesScrolledToTop extends ChatMessagesEvent {
  final String eventId;
  MessagesScrolledToTop(this.eventId);

  @override
  List<Object> get props => [eventId];
}

class NewPageLoaded extends ChatMessagesEvent {}

class MessagesBuilt extends ChatMessagesEvent {}

part of 'chat_snippet_bloc.dart';

abstract class ChatSnippetEvent extends Equatable {
  const ChatSnippetEvent();

  @override
  List<Object?> get props => [];
}

class ChatsScreenInitialized extends ChatSnippetEvent {
  final List<String> chatIds;
  ChatsScreenInitialized(this.chatIds);
}

class ChatsScreenClosing extends ChatSnippetEvent {}

class ChatSnippetChnaged extends ChatSnippetEvent {
  final ChatSnippet chatSnippet;
  ChatSnippetChnaged(this.chatSnippet);

  @override
  List<Object?> get props => [chatSnippet];
}

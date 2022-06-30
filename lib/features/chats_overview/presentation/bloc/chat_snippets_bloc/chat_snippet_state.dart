part of 'chat_snippet_bloc.dart';

abstract class ChatSnippetsState extends Equatable {
  const ChatSnippetsState();

  @override
  List<Object> get props => [];
}

class ChatSnippetsLoading extends ChatSnippetsState {}

class ChatSnippetsFailure extends ChatSnippetsState {
  final String message;
  ChatSnippetsFailure(this.message);

  @override
  List<Object> get props => [message];
}

class ChatSnippetNetworkFailure extends ChatSnippetsFailure {
  ChatSnippetNetworkFailure(String message) : super(message);
}

class ChatSnippetServerFailure extends ChatSnippetsFailure {
  ChatSnippetServerFailure(String message) : super(message);
}

class ChatSnippetsLoaded extends ChatSnippetsState {
  final List<ChatSnippet> chatSnippets;
  ChatSnippetsLoaded(this.chatSnippets);

  ChatSnippetsLoaded onSnippetChanged(ChatSnippet chatSnippet) {
    return ChatSnippetsLoaded(
        ChatSnippetOrganizer.orederChatSnippetsOnSnippetChange(
      this.chatSnippets,
      chatSnippet,
    ));
  }

  @override
  List<Object> get props => [chatSnippets];
}

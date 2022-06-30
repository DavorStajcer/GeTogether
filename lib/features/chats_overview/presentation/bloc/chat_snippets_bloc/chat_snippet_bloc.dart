import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/util/chat_snippet_orginizer.dart';

import 'package:get_together_app/features/chats_overview/domain/enitites/chat_snippet.dart';
import 'package:get_together_app/features/chats_overview/domain/usecases/get_inital_chat_snippets.dart';
import 'package:get_together_app/features/chats_overview/domain/usecases/listen_to_chat_snippets_change.dart';

part 'chat_snippet_event.dart';
part 'chat_snippet_state.dart';

class ChatSnippetsBloc extends Bloc<ChatSnippetEvent, ChatSnippetsState> {
  ListenToChatSnippetsChange listenToChatSnippetsChange;
  GetInitialChatSnippets getInitialChatSnippets;
  ChatSnippetsBloc({
    required this.listenToChatSnippetsChange,
    required this.getInitialChatSnippets,
  }) : super(ChatSnippetsLoading());

  @override
  Stream<ChatSnippetsState> mapEventToState(
    ChatSnippetEvent event,
  ) async* {
    if (event is ChatsScreenInitialized) {
      emit(ChatSnippetsLoading());
      final response = await getInitialChatSnippets(event.chatIds);
      yield response.fold<ChatSnippetsState>((failure) {
        if (failure is NetworkFailure)
          return ChatSnippetNetworkFailure(failure.message);
        else
          return ChatSnippetServerFailure(failure.message);
      }, (chatSnippets) {
        listenToChatSnippetsChange.call(this, chatSnippets);
        return ChatSnippetsLoaded(chatSnippets);
      });
    }
    if (event is ChatSnippetChnaged) {
      if (state is ChatSnippetsLoaded)
        emit((state as ChatSnippetsLoaded).onSnippetChanged(event.chatSnippet));
    }
    if (event is ChatsScreenClosing) {
      await listenToChatSnippetsChange.stop();
    }
  }
}

import 'dart:async';

import 'package:get_together_app/features/chats_overview/domain/enitites/chat_snippet.dart';
import 'package:get_together_app/features/chats_overview/domain/repositories/chat_snippets_repository.dart';
import 'package:get_together_app/features/chats_overview/presentation/bloc/chat_snippets_bloc/chat_snippet_bloc.dart';

class ListenToChatSnippetsChange {
  ChatSnippetsReposiotry chatSnippetsReposiotry;

  ListenToChatSnippetsChange(this.chatSnippetsReposiotry);
  StreamSubscription? subscription;

  void call(ChatSnippetsBloc bloc, List<ChatSnippet> chatSnippets) {
    subscription = chatSnippetsReposiotry
        .listenToChatSnippetsChanges(chatSnippets)
        .listen((chatSnippet) => bloc.add(ChatSnippetChnaged(chatSnippet)));
  }

  Future<void> stop() async {
    if (subscription != null) await subscription!.cancel();
    await chatSnippetsReposiotry.stopListeningToChatSnippetChanges();
  }
}

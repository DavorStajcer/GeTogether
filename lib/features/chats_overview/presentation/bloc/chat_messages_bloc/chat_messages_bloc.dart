import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/core/util/date_formater.dart';
import 'package:get_together_app/features/chats_overview/domain/enitites/message.dart';
import 'package:get_together_app/features/chats_overview/domain/usecases/listen_to_messages.dart';
import 'package:get_together_app/features/chats_overview/domain/usecases/load_initial_messages.dart';
import 'package:get_together_app/features/chats_overview/domain/usecases/load_new_page.dart';
import 'package:get_together_app/features/chats_overview/domain/usecases/mark_chat_snippet_read.dart';
import 'package:get_together_app/features/chats_overview/domain/usecases/reset_unread_chat_messages.dart';
import 'package:get_together_app/features/chats_overview/presentation/widgets/chat_messages.dart';
import 'package:get_together_app/features/chats_overview/presentation/widgets/message_bubble_left.dart';
import 'package:get_together_app/features/chats_overview/presentation/widgets/message_bubble_right.dart';

part 'chat_messages_event.dart';
part 'chat_messages_state.dart';

class ChatMessagesBloc extends Bloc<ChatMessagesEvent, ChatMessagesState> {
  final ListenToMessages listenToMessages;
  final LoadNewPage loadNewPage;
  final LoadInitalMessages loadInitalMessages;
  final ResetUnreadChatMessages resetUnreadChatMessages;
  final MarkChatSnippetRead markChatSnippetRead;
  bool _canLoadMorePages = true;
  ChatMessagesBloc({
    required this.listenToMessages,
    required this.loadNewPage,
    required this.resetUnreadChatMessages,
    required this.loadInitalMessages,
    required this.markChatSnippetRead,
  }) : super(ChatMessagesLoading());

  @override
  Stream<ChatMessagesState> mapEventToState(
    ChatMessagesEvent event,
  ) async* {
    log(event.toString());
    if (event is ChatMessagesScreenInitialized) {
      final response = await loadInitalMessages(event.eventId);
      yield _onScreenInitializedToState(response, event.eventId);
      final firstNextPa = await loadNewPage(event.eventId);
    }
    if (event is LeavingChatScreen) {
      await listenToMessages.stop();
      await markChatSnippetRead(event.eventId);
      await resetUnreadChatMessages(NoParameters());
    }
    if (event is MessagesScrolledToTop) {
      if (_canLoadMorePages) {
        final response = await loadNewPage(event.eventId);
        yield _onScroilledToTop(response);
        _canLoadMorePages = false;
      }
    }
    if (event is MessagesAdded) yield _onNewMessageAdded(event.response);
    if (event is NewPageLoaded)
      _canLoadMorePages = loadNewPage.canLoadMorePages();
    if (event is MessagesBuilt)
      yield InitialMessagesDisplayed((state as MessagesDisplayChanged));
  }

  ChatMessagesState _onScreenInitializedToState(
      Either<Failure, List<Message>> response, String eventId) {
    return response.fold(
      (failure) {
        if (failure is NetworkFailure)
          return ChatMessagesNetworkFailure(failure.message);
        else
          return ChatMessagesServerFailure(failure.message);
      },
      (messages) {
        listenToMessages(this, eventId);
        return InitialMessagesLoaded.fromInitialMessages(messages);
      },
    );
  }

  ChatMessagesState _onScroilledToTop(Either<Failure, List<Message>> response) {
    return response.fold(
        (failure) =>
            FailedToDisplayMoreMessages((state as MessagesDisplayChanged)),
        (messages) => NewPageAdded.addOnLoadedMessages(
            (state as MessagesDisplayChanged), messages));
  }

  ChatMessagesState _onNewMessageAdded(
      Either<Failure, List<Message>> response) {
    log("ON MESSAGE ADDED");
    return response.fold(
        (failure) =>
            FailedToDisplayMoreMessages((state as MessagesDisplayChanged)),
        (messages) => NewMessagesAdded.addOnLoadedMessages(
            (state as MessagesDisplayChanged), messages));
  }
}

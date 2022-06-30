import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_together_app/features/home/domain/usecase/listen_to_new_chat_messages.dart';

part 'new_chats_event.dart';
part 'new_chats_state.dart';

class NewChatsBloc extends Bloc<NewChatsEvent, NewChatsState> {
  ListenToNewChatMessages listenToNewChatMessages;
  NewChatsBloc(this.listenToNewChatMessages) : super(NewChatsStateInitial());

  @override
  Stream<NewChatsState> mapEventToState(
    NewChatsEvent event,
  ) async* {
    if (event is HomeScreenOpened)
      listenToNewChatMessages(this);
    else if (event is NewChatsClosing)
      listenToNewChatMessages.stop();
    else
      emit(NewChatsStateLoaded((event as NewChatsNumChanged).num));
  }
}

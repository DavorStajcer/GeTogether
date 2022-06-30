import 'dart:async';

import 'package:get_together_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/features/home/domain/repositories/live_notifications_and_messages_repository.dart';
import 'package:get_together_app/features/home/presentation/bloc/new_chats_bloc/new_chats_bloc.dart';

class ListenToNewChatMessages {
  LiveNotificationsAndMessagesRepository liveNotificationsAndMessagesRepository;
  ListenToNewChatMessages(this.liveNotificationsAndMessagesRepository);
  late StreamSubscription<int> subscription;

  void call(NewChatsBloc newChatsBloc) {
    subscription = liveNotificationsAndMessagesRepository
        .listenToNewMessageNum()
        .listen((newChatMessagesNum) {
      newChatsBloc.add(NewChatsNumChanged(newChatMessagesNum));
    });
  }

  void stop() {
    subscription.cancel();
  }
}

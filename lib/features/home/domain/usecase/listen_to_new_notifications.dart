import 'dart:async';

import 'package:get_together_app/features/home/domain/repositories/live_notifications_and_messages_repository.dart';
import 'package:get_together_app/features/home/presentation/bloc/new_notifications_bloc/new_notifications_bloc.dart';

class ListenToNewNotifications {
  LiveNotificationsAndMessagesRepository liveNotificationsAndMessagesRepository;
  ListenToNewNotifications(this.liveNotificationsAndMessagesRepository);
  late StreamSubscription<int> subscription;

  void call(NewNotificationsBloc bloc) {
    subscription = liveNotificationsAndMessagesRepository
        .listenToNewNotificationsNum()
        .listen((numOfNewMessages) {
      bloc.add(NewNotificationNumChanged(numOfNewMessages));
    });
  }

  void stop() {
    subscription.cancel();
  }
}

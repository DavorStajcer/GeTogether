import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_together_app/features/home/domain/usecase/listen_to_new_notifications.dart';

part 'new_notifications_event.dart';
part 'new_notifications_state.dart';

class NewNotificationsBloc
    extends Bloc<NewNotificationsEvent, NewNotificationsState> {
  ListenToNewNotifications listenToNewNotifications;
  NewNotificationsBloc(this.listenToNewNotifications)
      : super(NewNotificationsInitial());

  @override
  Stream<NewNotificationsState> mapEventToState(
    NewNotificationsEvent event,
  ) async* {
    if (event is HomeScreenOpened)
      listenToNewNotifications(this);
    else if (event is NewNotificationsClosing)
      listenToNewNotifications.stop();
    else
      emit(NewNotificationsLoaded((event as NewNotificationNumChanged).num));
  }
}

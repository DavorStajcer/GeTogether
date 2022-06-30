import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/features/notifications_overview/domain/entities/notification.dart';
import 'package:get_together_app/features/notifications_overview/domain/usecase/get_user_notifications.dart';
import 'package:get_together_app/features/notifications_overview/domain/usecase/reset_unread_notifications.dart';
import 'notifications_bloc_state.dart';
import 'notifications_bloc_event.dart';

class NotificationsBloc
    extends Bloc<NotificationsBlocEvent, NotificationsState> {
  final GetUserNotifications getUserNotifications;
  final ResetUnreadNotifications resetUnreadNotifications;
  NotificationsBloc({
    required this.getUserNotifications,
    required this.resetUnreadNotifications,
  }) : super(NotificationsLoading());

  @override
  Stream<NotificationsState> mapEventToState(
    NotificationsBlocEvent event,
  ) async* {
    if (event is NotificationsScreenInitialized) {
      final response = await getUserNotifications(NoParameters());
      yield _mapScreenInitResponseToState(response);
    } else if (event is NotificationsScrolledToEnd) {
      final response = await getUserNotifications(NoParameters());
      yield _mapScreenScrolledResponseToState(response);
    } else if (event is NotificationScreenLeft) {
      await getUserNotifications.resetNotificationFetching();
      await resetUnreadNotifications(NoParameters());
    }
  }

  NotificationsState _mapScreenInitResponseToState(
      Either<Failure, List<EventInfoNotification>> response) {
    return response.fold<NotificationsState>((failure) {
      if (failure is NetworkFailure)
        return NotificationsNetworkFailure(failure.message);
      else
        return NotificationsServerFailure(failure.message);
    }, (notifications) {
      return NotificationsLoaded(notifications);
    });
  }

  NotificationsState _mapScreenScrolledResponseToState(
      Either<Failure, List<EventInfoNotification>> response) {
    return response.fold((failure) {
      if (failure is NetworkFailure)
        return NotificationsNetworkFailure(failure.message);
      else
        return NotificationsServerFailure(failure.message);
    }, (notifications) {
      return NotificationsLoaded.addOnLoadedNotifications(
          (state as NotificationsLoaded).notifications, notifications);
    });
  }
}

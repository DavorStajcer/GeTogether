import 'package:get_together_app/features/authentication/di/authentication_di.dart';
import 'package:get_together_app/features/notifications_overview/data/repositoires/user_notifications_repository_impl.dart';
import 'package:get_together_app/features/notifications_overview/domain/repositories/user_notifications_repository.dart';
import 'package:get_together_app/features/notifications_overview/domain/usecase/get_user_notifications.dart';
import 'package:get_together_app/features/notifications_overview/domain/usecase/reset_unread_notifications.dart';
import 'package:get_together_app/features/notifications_overview/presentation/bloc/event_answer_cubit/event_answer_cubit.dart';
import 'package:get_together_app/features/notifications_overview/presentation/bloc/notifications_bloc/notifications_bloc.dart';

void initNotificationsDi() {
  getIt.registerSingleton<UserNotificationsRepository>(
      UserNotificationsRepositoryImpl(
          networkInfo: getIt(), locationService: getIt()));
  getIt.registerSingleton(
      GetUserNotifications(userNotificationsRepository: getIt()));
  getIt.registerSingleton(ResetUnreadNotifications(getIt()));
  getIt.registerFactory(() => NotificationsBloc(
      getUserNotifications: getIt(), resetUnreadNotifications: getIt()));
  getIt.registerFactory(() =>
      EventAnswerCubit(addUserToEvent: getIt(), declineJoinRequest: getIt()));
}

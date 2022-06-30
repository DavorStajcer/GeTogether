import 'package:get_together_app/features/authentication/di/authentication_di.dart';
import 'package:get_together_app/features/home/data/repositoires/live_notifications_and_messages_repository_impl.dart';
import 'package:get_together_app/features/home/domain/repositories/live_notifications_and_messages_repository.dart';
import 'package:get_together_app/features/home/domain/usecase/listen_to_new_chat_messages.dart';
import 'package:get_together_app/features/home/domain/usecase/listen_to_new_notifications.dart';
import 'package:get_together_app/features/home/presentation/bloc/new_chats_bloc/new_chats_bloc.dart';
import 'package:get_together_app/features/home/presentation/bloc/new_notifications_bloc/new_notifications_bloc.dart';
import 'package:get_together_app/features/user_events_overview/presentation/bloc/cubit/user_events_cubit.dart';
import '../presentation/bloc/nav_bar_cubit/nav_bar_cubit.dart';
import '../presentation/bloc/nav_bar_style_cubit/nav_bar_style_cubit.dart';

void initHomeDi() {
  getIt.registerFactory(() => NavBarCubit());
  getIt.registerFactory(() => NavBarStyleCubit());
  getIt.registerFactory(() => UserEventsCubit(getIt()));
  getIt.registerSingleton<LiveNotificationsAndMessagesRepository>(
      LiveNotificationsAndMessagesRepositoryImpl(networkInfo: getIt()));
  getIt.registerSingleton(ListenToNewChatMessages(getIt()));
  getIt.registerFactory(() => NewChatsBloc(getIt()));
  getIt.registerSingleton(ListenToNewNotifications(getIt()));
  getIt.registerFactory(() => NewNotificationsBloc(getIt()));
}

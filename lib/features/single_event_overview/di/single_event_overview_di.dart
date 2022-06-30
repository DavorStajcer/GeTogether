import 'package:get_together_app/features/authentication/di/authentication_di.dart';
import 'package:get_together_app/features/notifications_overview/domain/usecase/send_join_request.dart';
import 'package:get_together_app/features/single_event_overview/data/repositoires/user_events_repository_impl.dart';
import 'package:get_together_app/features/single_event_overview/domain/repositoires/user_events_repository.dart';
import 'package:get_together_app/features/single_event_overview/domain/usecase/add_user_to_event.dart';
import 'package:get_together_app/features/single_event_overview/domain/usecase/check_is_current_user_event_admin.dart';
import 'package:get_together_app/features/single_event_overview/domain/usecase/check_is_user_joined.dart';
import 'package:get_together_app/features/single_event_overview/domain/usecase/decline_join_request.dart';
import 'package:get_together_app/features/single_event_overview/domain/usecase/remove_user_from_event.dart';
import 'package:get_together_app/features/single_event_overview/presentation/bloc/join_event_cubit/join_event_cubit.dart';
import 'package:get_together_app/features/single_event_overview/presentation/bloc/single_event_screen_cubit/single_event_screen_cubit.dart';

void initSingleEventDi() {
  getIt.registerSingleton(CheckIsCurrentUserEventAdmin());
  getIt.registerFactory(
      () => SingleEventScreenCubit(checkIsCurrentUserEventAdmin: getIt()));
  getIt.registerSingleton<UserEventsRepository>(
    UserEventsRepositoryImpl(networkInfo: getIt(), locationService: getIt()),
  );
  getIt.registerSingleton(AddUserToEvent(userEventsRepository: getIt()));
  getIt.registerSingleton(DeclineJoinRequest(getIt()));
  getIt.registerSingleton(RemoveUserFromEvent(userEventsRepository: getIt()));
  getIt.registerSingleton(CheckIsUserJoined(userEventsRepository: getIt()));
  getIt.registerSingleton(SendJoinRequest(getIt()));
  getIt.registerFactory(
    () => JoinEventCubit(
        addUserToEvent: getIt(),
        sendJoinRequest: getIt(),
        removeUserFromEvent: getIt(),
        checkIsUserJoined: getIt()),
  );
}

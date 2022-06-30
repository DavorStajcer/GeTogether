import 'package:get_together_app/features/authentication/di/authentication_di.dart';
import 'package:get_together_app/features/user_events_overview/domain/usecase/get_all_user_events.dart';

void initUserEventsDi() {
  getIt.registerSingleton<GetAllUserEvents>(GetAllUserEvents(getIt()));
}

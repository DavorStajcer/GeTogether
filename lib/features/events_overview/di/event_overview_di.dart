import 'package:get_together_app/features/authentication/di/authentication_di.dart';
import 'package:get_together_app/features/events_overview/domain/usecases/getEventsForCurrentLocation.dart';
import 'package:get_together_app/features/events_overview/presentation/bloc/event_pick_cubit/event_pick_cubit_cubit.dart';
import 'package:get_together_app/features/events_overview/presentation/bloc/load_events_bloc/events_overview_bloc.dart';

void initEventsOverviewDi() {
  getIt.registerSingleton(GetEventsForCurrentLocation(getIt()));
  getIt.registerFactory(() => EventPickCubit());
  getIt.registerFactory(
    () => EventsOverviewBloc(
      getEventsForCurrentLocation: getIt(),
      locationService: getIt(),
    ),
  );
}

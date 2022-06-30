import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';
import 'package:get_together_app/features/user_events_overview/domain/usecase/get_all_user_events.dart';

part 'user_events_state.dart';

class UserEventsCubit extends Cubit<UserEventsState> {
  GetAllUserEvents getAllUserEvents;
  UserEventsCubit(this.getAllUserEvents) : super(UserEventsInitial());

  void fetchEvents() async {
    emit(UserEventsInitial());
    final response = await getAllUserEvents(NoParameters());
    response.fold((failure) {
      if (failure is NetworkFailure)
        emit(UserEventsNetworkFailure(failure.message));
      else
        emit(UserEventsServerFailure(failure.message));
    }, (events) => emit(UserEventsLoaded(events)));
  }
}

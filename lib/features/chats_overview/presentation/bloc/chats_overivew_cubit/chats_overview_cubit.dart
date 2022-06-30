import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/features/chats_overview/domain/usecases/get_all_user_event_ids.dart';

part 'chats_overview_state.dart';

class ChatsOverviewCubit extends Cubit<ChatsOverviewState> {
  GetAllUserEventIds getAllUserEventIds;
  ChatsOverviewCubit(this.getAllUserEventIds) : super(ChatsOverviewLoading());

  void getAllEvents() async {
    final response = await getAllUserEventIds(NoParameters());
    response.fold((failure) {
      if (failure is NetworkFailure)
        emit(ChatsOverviewNetworkFailure(failure.message));
      else
        emit(ChatsOverviewServerFailure(failure.message));
    }, (events) => emit(ChatsOverviewLoaded(events)));
  }
}

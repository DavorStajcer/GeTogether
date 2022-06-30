import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_together_app/features/notifications_overview/data/models/notification_model.dart';
import 'package:get_together_app/features/single_event_overview/domain/usecase/add_user_to_event.dart';
import 'package:get_together_app/features/single_event_overview/domain/usecase/decline_join_request.dart';

part 'event_answer_state.dart';

class EventAnswerCubit extends Cubit<EventAnswerState> {
  final AddUserToEvent addUserToEvent;
  final DeclineJoinRequest declineJoinRequest;
  EventAnswerCubit({
    required this.addUserToEvent,
    required this.declineJoinRequest,
  }) : super(EventAnswerInitial());

  void acceptJoinRequest(JoinEventNotificationModel notification) async {
    emit(EventAnswerLoading());
    final response = await addUserToEvent(notification);
    response.fold((failure) => emit(EventAnswerFailure()),
        (success) => emit(EventAnswerAccepted()));
  }

  void declineRequest(JoinEventNotificationModel notification) async {
    emit(EventAnswerLoading());
    final response = await declineJoinRequest(notification);
    response.fold((failure) => emit(EventAnswerFailure()),
        (success) => emit(EventAnswerRejected()));
  }
}

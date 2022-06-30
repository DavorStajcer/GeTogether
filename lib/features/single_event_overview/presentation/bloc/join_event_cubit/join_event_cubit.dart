import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';
import 'package:get_together_app/features/notifications_overview/domain/usecase/send_join_request.dart';
import 'package:get_together_app/features/single_event_overview/data/repositoires/user_events_repository_impl.dart';
import 'package:get_together_app/features/single_event_overview/domain/usecase/add_user_to_event.dart';
import 'package:get_together_app/features/single_event_overview/domain/usecase/check_is_user_joined.dart';
import 'package:get_together_app/features/single_event_overview/domain/usecase/remove_user_from_event.dart';

part 'join_event_state.dart';

class JoinEventCubit extends Cubit<JoinEventState> {
  final CheckIsUserJoined checkIsUserJoined;
  final SendJoinRequest sendJoinRequest;
  final AddUserToEvent addUserToEvent;
  final RemoveUserFromEvent removeUserFromEvent;
  JoinEventCubit({
    required this.sendJoinRequest,
    required this.checkIsUserJoined,
    required this.addUserToEvent,
    required this.removeUserFromEvent,
  }) : super(JoinEventLoading());

  void geUserJoinedStatus(BuildContext context, Event event) async {
    final response = await checkIsUserJoined(event);
    response.fold((failure) {
      if (failure is NetworkFailure)
        emit(JoinEventNetworkFailure(failure.message));
      else
        emit(JoinEventServerFailure(failure.message));
    }, (userJoineStatus) async {
      if (userJoineStatus == UserJoinStatus.joined)
        emit(JoinEventFinished(buttonData: ButtonJoinedUi(context)));
      else if (userJoineStatus == UserJoinStatus.requested)
        emit(JoinEventFinished(buttonData: ButtonRequestedUi(context)));
      else
        emit(JoinEventFinished(buttonData: ButtonNotJoinedUi(context)));
    });
  }

  void makeRequestToJoin(BuildContext context, Event event) async {
    final response = await sendJoinRequest.call(event);
    emit(JoinEventLoading());
    response.fold((failure) {
      if (failure is NetworkFailure)
        emit(JoinEventNetworkFailure(failure.message));
      else
        emit(JoinEventServerFailure(failure.message));
    }, (success) {
      emit(JoinEventFinished(buttonData: ButtonRequestedUi(context)));
    });
  }

  void leaveEvent(BuildContext context, Event event) async {
    final response = await removeUserFromEvent(event);
    emit(JoinEventLoading());
    response.fold((failure) {
      if (failure is NetworkFailure)
        emit(JoinEventNetworkFailure(failure.message));
      else
        emit(JoinEventServerFailure(failure.message));
    },
        (success) =>
            emit(JoinEventFinished(buttonData: ButtonNotJoinedUi(context))));
  }
}

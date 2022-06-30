import 'dart:developer';

import 'package:get_together_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';
import 'package:get_together_app/features/single_event_overview/data/repositoires/user_events_repository_impl.dart';
import 'package:get_together_app/features/single_event_overview/domain/repositoires/user_events_repository.dart';

class CheckIsUserJoined extends Usecase<UserJoinStatus, Event> {
  final UserEventsRepository userEventsRepository;
  CheckIsUserJoined({required this.userEventsRepository});

  @override
  Future<Either<Failure, UserJoinStatus>> call(Event event) async {
    final response = await userEventsRepository.checkIsUserJoined(event);
    log("USECASE RESPONSE -> $response");
    return response;
  }
}

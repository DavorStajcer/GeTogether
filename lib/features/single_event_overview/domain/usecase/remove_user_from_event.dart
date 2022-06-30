import 'package:get_together_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';
import 'package:get_together_app/features/single_event_overview/domain/repositoires/user_events_repository.dart';

class RemoveUserFromEvent extends Usecase<Success, Event> {
  final UserEventsRepository userEventsRepository;
  RemoveUserFromEvent({required this.userEventsRepository});

  @override
  Future<Either<Failure, Success>> call(Event event) async {
    return await userEventsRepository.removeUserFromEvent(event);
  }
}

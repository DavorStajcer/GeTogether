import 'package:get_together_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';
import 'package:get_together_app/features/single_event_overview/domain/repositoires/user_events_repository.dart';

class GetAllUserEvents extends Usecase<List<Event>, NoParameters> {
  final UserEventsRepository userEventsRepository;
  GetAllUserEvents(this.userEventsRepository);

  @override
  Future<Either<Failure, List<Event>>> call(NoParameters param) async {
    return await userEventsRepository.getAllUserEvents();
  }
}

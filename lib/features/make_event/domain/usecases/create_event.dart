import 'package:get_together_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/features/events_overview/domain/repositoires/events_repository.dart';
import 'package:get_together_app/features/make_event/domain/entities/create_event_data.dart';

class CreateEvent extends Usecase<Success, CreateEventData> {
  final EventsRepository eventsRepository;
  CreateEvent(this.eventsRepository);

  @override
  Future<Either<Failure, Success>> call(
          CreateEventData createEventData) async =>
      await eventsRepository.createEvent(createEventData);
}

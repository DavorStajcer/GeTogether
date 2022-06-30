import 'package:get_together_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';
import 'package:get_together_app/features/events_overview/domain/repositoires/events_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetEventsForCurrentLocation extends Usecase<List<Event>, LatLng> {
  final EventsRepository eventsRepository;
  GetEventsForCurrentLocation(this.eventsRepository);

  @override
  Future<Either<Failure, List<Event>>> call(LatLng currentLocation) {
    return eventsRepository.getAllEvents(currentLocation);
  }
}

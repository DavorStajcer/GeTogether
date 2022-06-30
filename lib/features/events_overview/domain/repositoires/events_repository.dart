import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';
import 'package:get_together_app/features/make_event/domain/entities/create_event_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class EventsRepository {
  Future<Either<Failure, List<Event>>> getAllEvents(LatLng currentLocation);
  Future<Either<Failure, Success>> createEvent(CreateEventData event);
}

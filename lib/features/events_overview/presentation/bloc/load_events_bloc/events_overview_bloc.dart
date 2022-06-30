import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/maps/location_service.dart';
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';
import 'package:get_together_app/features/events_overview/domain/usecases/getEventsForCurrentLocation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'events_overview_event.dart';
part 'events_overview_state.dart';

class EventsOverviewBloc
    extends Bloc<EventsOverviewEvent, EventsOverviewState> {
  final GetEventsForCurrentLocation getEventsForCurrentLocation;
  final LocationService locationService;
  EventsOverviewBloc({
    required this.getEventsForCurrentLocation,
    required this.locationService,
  }) : super(EventsOverviewLoading());

  @override
  Stream<EventsOverviewState> mapEventToState(
    EventsOverviewEvent event,
  ) async* {
    if (event is EventsScreenInitialized) yield* _onScreenInitialized();
  }

  Stream<EventsOverviewState> _onScreenInitialized() async* {
    final locationResponse = await locationService.getLocation();
    yield* locationResponse.fold((
      locationFailure,
    ) async* {
      if (locationFailure is NetworkFailure)
        yield EventsOverviewNetworkFailure(locationFailure.message);
      else
        yield EventsOverviewServerFailure(locationFailure.message);
    }, (
      currentPosition,
    ) async* {
      final Either<Failure, List<Event>> response =
          await getEventsForCurrentLocation(
        LatLng(currentPosition.latitude, currentPosition.longitude),
      );

      yield* response.fold((failure) async* {
        if (failure is NetworkFailure)
          yield EventsOverviewNetworkFailure(failure.message);
        else
          yield EventsOverviewServerFailure(failure.message);
      }, (listOfEvents) async* {
        yield EventsOverviewLoaded(events: listOfEvents);
      });
    });
  }
}

//@dart=2.6

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';
import 'package:get_together_app/features/events_overview/domain/usecases/getEventsForCurrentLocation.dart';
import 'package:get_together_app/features/events_overview/presentation/bloc/load_events_bloc/events_overview_bloc.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_card_order_cubit/event_card_order_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';
import '../../../core/location_service_mock.dart';

class GetEventsForCurrentLocationMock extends Mock
    implements GetEventsForCurrentLocation {}

void main() {
  LocationServiceMock locationServiceMock;
  GetEventsForCurrentLocationMock getEventsForCurrentLocationMock;
  EventsOverviewBloc eventsOverviewBloc;
  LatLng tCurrentLocation;
  Position tPosition;
  Event tEvent;

  setUp(() {
    locationServiceMock = LocationServiceMock();
    getEventsForCurrentLocationMock = GetEventsForCurrentLocationMock();
    eventsOverviewBloc = EventsOverviewBloc(
      getEventsForCurrentLocation: getEventsForCurrentLocationMock,
      locationService: locationServiceMock,
    );
    tPosition = tPosition = Position(
      accuracy: 1,
      altitude: 1,
      floor: 1,
      heading: 1,
      latitude: 1,
      longitude: 1,
      speedAccuracy: 1,
      timestamp: DateTime.now(),
      speed: 1,
    );
    tCurrentLocation = LatLng(tPosition.latitude, tPosition.longitude);
    tEvent = Event(
        eventId: "undefinedNow",
        eventType: EventType.food,
        dateString: "1.1.1111",
        timeString: "11:11",
        location: tCurrentLocation,
        adminId: "tUserId",
        adminUsername: "username",
        adminImageUrl: "imageUrl",
        adminRating: -1,
        numberOfPeople: 1,
        description: "description",
        peopleImageUrls: {});
  });

  test("inital state should be EventsOverviewLoading", () {
    expect(eventsOverviewBloc.state, EventsOverviewLoading());
  });

  group("no errors", () {
    setUp(() {
      when(locationServiceMock.getLocation())
          .thenAnswer((realInvocation) async => Right(tPosition));
      when(getEventsForCurrentLocationMock(any))
          .thenAnswer((realInvocation) async => Right([
                tEvent,
                tEvent,
              ]));
    });

    //ScreenInitializedEvent

    blocTest(
      "ScreenInitialized event -> make a call to Location service for current location",
      build: () => eventsOverviewBloc,
      act: (bloc) =>
          (bloc as EventsOverviewBloc).add(EventsScreenInitialized()),
      verify: (bloc) => verify(locationServiceMock.getLocation()).called(1),
    );

    blocTest(
      "ScreenInitialized event -> make a call to GetEventsForCurrentLocation usecase",
      build: () => eventsOverviewBloc,
      act: (bloc) =>
          (bloc as EventsOverviewBloc).add(EventsScreenInitialized()),
      verify: (bloc) =>
          verify(getEventsForCurrentLocationMock.call(tCurrentLocation)),
    );
    blocTest(
      "ScreenInitialized event -> should return EventOverviewLoading and ",
      build: () => eventsOverviewBloc,
      act: (bloc) =>
          (bloc as EventsOverviewBloc).add(EventsScreenInitialized()),
      expect: () => [
        EventsOverviewLoaded(events: [
          tEvent,
          tEvent,
        ])
      ],
    );
  });

  group("errors", () {
    //ScreenInitializedEvent
    blocTest(
      "ScreenInitialized event -> return network failure when location service returns NetworkFailure",
      build: () {
        when(locationServiceMock.getLocation()).thenAnswer(
            (realInvocation) async =>
                Left(NetworkFailure(message: "network failure")));
        return eventsOverviewBloc;
      },
      act: (bloc) =>
          (bloc as EventsOverviewBloc).add(EventsScreenInitialized()),
      expect: () => [
        EventsOverviewNetworkFailure("network failure"),
      ],
    );

    blocTest(
      "ScreenInitialized event -> return server failure when location service returns ServerFailure",
      build: () {
        when(locationServiceMock.getLocation()).thenAnswer(
          (realInvocation) async =>
              Left(ServerFailure(message: "server failure")),
        );
        return eventsOverviewBloc;
      },
      act: (bloc) =>
          (bloc as EventsOverviewBloc).add(EventsScreenInitialized()),
      expect: () => [
        EventsOverviewServerFailure("server failure"),
      ],
    );

    blocTest(
      "ScreenInitialized event -> return network failure when getting events usecase returns NetworkFailure",
      build: () {
        when(locationServiceMock.getLocation()).thenAnswer(
          (realInvocation) async => Right(tPosition),
        );
        when(getEventsForCurrentLocationMock(any)).thenAnswer(
            (realInvocation) async =>
                Left(NetworkFailure(message: "network failure")));
        return eventsOverviewBloc;
      },
      act: (bloc) =>
          (bloc as EventsOverviewBloc).add(EventsScreenInitialized()),
      expect: () => [
        EventsOverviewNetworkFailure("network failure"),
      ],
    );

    blocTest(
      "ScreenInitialized event -> return network failure when getting events usecase returns NetworkFailure",
      build: () {
        when(locationServiceMock.getLocation()).thenAnswer(
          (realInvocation) async => Right(tPosition),
        );
        when(getEventsForCurrentLocationMock(any)).thenAnswer(
            (realInvocation) async =>
                Left(ServerFailure(message: "server failure")));
        return eventsOverviewBloc;
      },
      act: (bloc) =>
          (bloc as EventsOverviewBloc).add(EventsScreenInitialized()),
      expect: () => [
        EventsOverviewServerFailure("server failure"),
      ],
    );
  });
}

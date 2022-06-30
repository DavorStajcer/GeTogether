//@dart=2.6

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/features/events_overview/domain/repositoires/events_repository.dart';
import 'package:get_together_app/features/make_event/domain/entities/create_event_data.dart';
import 'package:get_together_app/features/make_event/domain/usecases/create_event.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_card_order_cubit/event_card_order_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';

class EventsRepositoryMock extends Mock implements EventsRepository {}

void main() {
  EventsRepositoryMock eventRepositoryMock;
  CreateEvent createEvent;
  CreateEventData tFinishedData;

  setUp(() {
    eventRepositoryMock = EventsRepositoryMock();
    createEvent = CreateEvent(eventRepositoryMock);
    tFinishedData = CreateEventData(
      type: EventType.games,
      location: LatLng(0, 0),
      dateString: "07.12.1998.",
      timeString: "21:10",
      description: "Some description",
    );

    when(eventRepositoryMock.createEvent(tFinishedData))
        .thenAnswer((realInvocation) async => Right(Success()));
  });

  test("should make a call to event repository", () async {
    await createEvent(tFinishedData);
    verify(eventRepositoryMock.createEvent(tFinishedData));
  });

  test("should return Success when all is good", () async {
    final response = await createEvent(tFinishedData);
    expect(response, Right(Success()));
  });
  test("should return NetworkFailure when repo returns network failure",
      () async {
    when(eventRepositoryMock.createEvent(tFinishedData))
        .thenAnswer((realInvocation) async => Left(NetworkFailure()));
    final response = await createEvent(tFinishedData);
    expect(response, Left(NetworkFailure()));
  });
  test("should return ServerFailure when repo returns network failure",
      () async {
    when(eventRepositoryMock.createEvent(tFinishedData))
        .thenAnswer((realInvocation) async => Left(ServerFailure()));
    final response = await createEvent(tFinishedData);
    expect(response, Left(ServerFailure()));
  });
}

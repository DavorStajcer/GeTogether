/* //@dart=2.6

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_card_order_cubit/event_card_order_cubit.dart';
import 'package:get_together_app/features/single_event_overview/domain/repositoires/user_events_repository.dart';
import 'package:get_together_app/features/single_event_overview/domain/usecase/check_is_user_joined.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';

class UserEventsRepositoryMock extends Mock implements UserEventsRepository {}

void main() {
  UserEventsRepositoryMock userEventsRepositoryMock;
  CheckIsUserJoined checkIsUserJoined;
  String tEventId;
  Event tEvent;

  setUp(() {
    tEventId = "tEventId";
    userEventsRepositoryMock = UserEventsRepositoryMock();
    checkIsUserJoined =
        CheckIsUserJoined(userEventsRepository: userEventsRepositoryMock);
    tEvent = Event(
      eventId: tEventId,
      eventType: EventType.coffe,
      dateString: "dateString",
      timeString: "timeString",
      location: LatLng(1, 1),
      adminId: "adminId",
      adminUsername: "adminUsername",
      adminImageUrl: "adminImageUrl",
      adminRating: -1,
      numberOfPeople: 0,
      description: "description",
      peopleImageUrls: {},
    );
  });

  group("no errors", () {
    test("should make a call to userEventsRepository", () async {
      when(userEventsRepositoryMock.checkIsUserJoined(any))
          .thenAnswer((realInvocation) async => Right(true));
      await checkIsUserJoined(tEvent);
      verify(userEventsRepositoryMock.checkIsUserJoined(tEvent));
    });

    test("should return true if repo returns true", () async {
      when(userEventsRepositoryMock.checkIsUserJoined(any))
          .thenAnswer((realInvocation) async => Right(true));
      final response = await checkIsUserJoined(tEvent);
      expect(response, Right(true));
    });
    test("should return false if repo returns false", () async {
      when(userEventsRepositoryMock.checkIsUserJoined(any))
          .thenAnswer((realInvocation) async => Right(false));
      final response = await checkIsUserJoined(tEvent);
      expect(response, Right(false));
    });
  });

  group("errors", () {
    test("should return server failure when repo returns server failure ",
        () async {
      when(userEventsRepositoryMock.checkIsUserJoined(any)).thenAnswer(
          (realInvocation) async =>
              Left(NetworkFailure(message: "someMessage")));
      final response = await checkIsUserJoined(tEvent);
      expect(response, Left(NetworkFailure(message: "someMessage")));
    });

    test("should return server failure when repo returns server failure ",
        () async {
      when(userEventsRepositoryMock.checkIsUserJoined(any)).thenAnswer(
          (realInvocation) async =>
              Left(ServerFailure(message: "someMessage")));
      final response = await checkIsUserJoined(tEvent);
      expect(response, Left(ServerFailure(message: "someMessage")));
    });
  });
}
 */
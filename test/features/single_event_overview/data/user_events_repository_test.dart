/* //@dart=2.6

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/features/authentication/data/repositories/user_auth_repository_impl.dart';
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_card_order_cubit/event_card_order_cubit.dart';
import 'package:get_together_app/features/single_event_overview/data/repositoires/user_events_repository_impl.dart';
import 'package:get_together_app/features/single_event_overview/domain/entities/event_join_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';

import '../../../core/location_service_mock.dart';
import '../../../firebase_mock/firebase_service_mock.dart';
import '../../../network_info_mock/network_info_mock.dart';

void main() {
  FirebaseServiceMock firebaseServiceMock;
  NetworkInfoMock networkInfoMock;
  UserEventsRepositoryImpl userEventsRepositoryImpl;
  LocationServiceMock locationServiceMock;
  String tUserId;
  String tEventId;
  Event tEvent;
  String tCity;
  EventJoinData tEventJoinData;

  setUp(() {
    firebaseServiceMock = FirebaseServiceMock();
    networkInfoMock = NetworkInfoMock();
    locationServiceMock = LocationServiceMock();
    userEventsRepositoryImpl = UserEventsRepositoryImpl(
      networkInfo: networkInfoMock,
      locationService: locationServiceMock,
      firebaseAuth: firebaseServiceMock.firebaseAuthMock,
      firebaseFirestore: firebaseServiceMock.firebaseFirestoreMock,
    );
    tUserId = "tUserId";
    tEventId = "tEventId";
    tCity = "tCity";
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
    tEventJoinData = EventJoinData(
      event: tEvent,
      eventChange: EventChange.join,
    );
    firebaseServiceMock.setUpFirebaseAuth();
    firebaseServiceMock.setUpFirebaseFirestore();
    firebaseServiceMock.setUpFirebaseUserId(tUserId);
  });

  group("no errors", () {
    setUp(() {
      networkInfoMock.setUpItHasConnection();

      when(locationServiceMock.mapLocationToCity(any))
          .thenAnswer((realInvocation) async => tCity);
      firebaseServiceMock.setUpFirestoreDocumentData({
        "eventIds": [
          "someOtherID",
          tEvent.eventId,
          "someOtherID",
        ]
      });
    });

    //checkIsUserJoined
    test("should make a call to firebaseAuth for current user", () async {
      await userEventsRepositoryImpl.checkIsUserJoined(tEvent);
      verify(firebaseServiceMock.firebaseAuthMock.currentUser);
    });
    test("should make a call to firebaseAuth for user id", () async {
      await userEventsRepositoryImpl.checkIsUserJoined(tEvent);
      verify(firebaseServiceMock.userMock.uid);
    });
    test("should make a call to location service for event city", () async {
      await userEventsRepositoryImpl.checkIsUserJoined(tEvent);
      verify(locationServiceMock.mapLocationToCity(tEvent.location));
    });
    test("should make a call to firebaseFirestore current user document",
        () async {
      await userEventsRepositoryImpl.checkIsUserJoined(tEvent);
      verify(firebaseServiceMock.firebaseFirestoreMock.collection("users"));
      verify(firebaseServiceMock.collectionReferenceMock.doc(tUserId));
      verify(
          firebaseServiceMock.documentReferenceMock.collection("user_events"));
      verify(firebaseServiceMock.collectionReferenceMock.doc(tCity));
    });

    test("should return false if data for events in that city doesnt exist",
        () async {
      firebaseServiceMock.setUpFirestoreDocumentData(null);
      final response = await userEventsRepositoryImpl.checkIsUserJoined(tEvent);
      expect(response, Right(false));
    });

    test("should return false if event id is not in the user events list",
        () async {
      firebaseServiceMock.setUpFirestoreDocumentData({
        "eventIds": [
          "notHere",
          "notHere",
        ]
      });
      final response = await userEventsRepositoryImpl.checkIsUserJoined(tEvent);
      expect(response, Right(false));
    });

    test("should return true if event id is in user events list", () async {
      final response = await userEventsRepositoryImpl.checkIsUserJoined(tEvent);
      expect(response, Right(true));
    });

    //changeUserJoinStatus()

    test("should make a call to firebaseAuth for current user", () async {
      await userEventsRepositoryImpl.changeUserJoinStatus(tEventJoinData);
      verify(firebaseServiceMock.firebaseAuthMock.currentUser);
    });
    test("should make a call to firebaseAuth for user id", () async {
      await userEventsRepositoryImpl.changeUserJoinStatus(tEventJoinData);
      verify(firebaseServiceMock.userMock.uid);
    });
    test("should make a call to location service for event city", () async {
      await userEventsRepositoryImpl.changeUserJoinStatus(tEventJoinData);
      verify(locationServiceMock.mapLocationToCity(tEvent.location));
    });
    test("should make a call to firebaseFirestore event ", () async {
      await userEventsRepositoryImpl.changeUserJoinStatus(tEventJoinData);
      verify(firebaseServiceMock.firebaseFirestoreMock.collection("events"));
      verify(firebaseServiceMock.collectionReferenceMock.doc(tCity));
      verify(
          firebaseServiceMock.documentReferenceMock.collection("city_events"));
      verify(firebaseServiceMock.collectionReferenceMock.doc(tEventId));
    });

    test("should make a call to update", () async {
      final response =
          await userEventsRepositoryImpl.changeUserJoinStatus(tEventJoinData);
      verify(firebaseServiceMock.documentReferenceMock.update(any));
    });

    //getAllUserEvents()

    test("should make a call to firebase auth for current user", () async {
      await userEventsRepositoryImpl.getAllUserEvents();
      verify(firebaseServiceMock.firebaseAuthMock.currentUser);
    });

    test("should make a call to user/{userId}/user_events", () async {
      await userEventsRepositoryImpl.getAllUserEvents();
      verify(firebaseServiceMock.firebaseFirestoreMock.collection("users"));
      verify(firebaseServiceMock.collectionReferenceMock.doc(tUserId));
      verify(
          firebaseServiceMock.documentReferenceMock.collection("user_events"));
    });
  });

  group("erros", () {
    test("should return network failure when no connection", () async {
      networkInfoMock.setUpNoConnection();
      final response = await userEventsRepositoryImpl.checkIsUserJoined(tEvent);
      expect(response, Left(NetworkFailure()));
    });
    test("should return server failure on firestore exception", () async {
      networkInfoMock.setUpItHasConnection();
      when(locationServiceMock.mapLocationToCity(any))
          .thenAnswer((realInvocation) async => tCity);
      firebaseServiceMock.setUpFirebaseFirestoreError();
      final response = await userEventsRepositoryImpl.checkIsUserJoined(tEvent);
      expect(response, Left(ServerFailure()));
    });
  });
}
 */
//@dart=2.6

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/features/authentication/data/models/user_data_model.dart';
import 'package:get_together_app/features/events_overview/data/repositories/events_repository_impl.dart';
import 'package:get_together_app/features/events_overview/domain/repositoires/events_repository.dart';
import 'package:get_together_app/features/make_event/domain/entities/create_event_data.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_card_order_cubit/event_card_order_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/location_service_mock.dart';
import '../../../../firebase_mock/firebase_service_mock.dart';
import '../../../../network_info_mock/network_info_mock.dart';

void main() {
  EventsRepository eventsRepository;
  FirebaseServiceMock firebaseServiceMock;
  NetworkInfoMock networkInfoMock;
  CreateEventData tFinishedData;
  UserModelPublic tUserProfileData;
/*   EventModel tEventModel;
  Event tEvent; */
  String tUserId;
  String tCity;
  LatLng tLocation;
  LocationServiceMock locationServiceMock;

  setUp(() {
    networkInfoMock = NetworkInfoMock();
    firebaseServiceMock = FirebaseServiceMock();
    locationServiceMock = LocationServiceMock();
    eventsRepository = EventsRepositoryImpl(
      networkInfo: networkInfoMock,
      firebaseAuth: firebaseServiceMock.firebaseAuthMock,
      firebaseFirestore: firebaseServiceMock.firebaseFirestoreMock,
      firebaseStorage: firebaseServiceMock.firebaseStorageMock,
      locationService: locationServiceMock,
    );
    tFinishedData = CreateEventData(
      type: EventType.games,
      location: LatLng(0, 0),
      dateString: "07.12.1998.",
      timeString: "21:10",
      description: "Some description",
    );
    /*    tEventModel = EventModel(
        eventId: "undefinedNow",
        eventType: tFinishedData.type,
        dateString: tFinishedData.dateString,
        timeString: tFinishedData.timeString,
        location: tFinishedData.location,
        adminId: tUserId,
        adminUsername: "username",
        adminImageUrl: "imageUrl",
        adminRating: -1,
        numberOfPeople: 0,
        description: tFinishedData.description,
        peopleImageUrls: []);
    tEvent = Event(
        eventId: "undefinedNow",
        eventType: tFinishedData.type,
        dateString: tFinishedData.dateString,
        timeString: tFinishedData.timeString,
        location: tFinishedData.location,
        adminId: tUserId,
        adminUsername: "username",
        adminImageUrl: "imageUrl",
        adminRating: -1,
        numberOfPeople: 0,
        description: tFinishedData.description,
        peopleImageUrls: []); */
    tUserProfileData = UserModelPublic(
      userId: tUserId,
      username: "username",
      imageUrl: "imageUrl",
      city: "city",
      country: "country",
      description: "description",
      friendsCount: 1,
      rating: 1,
      numberOfVotes: 1,
    );
    tUserId = "tUserId";

    firebaseServiceMock.setUpFirebaseFirestore();
    firebaseServiceMock.setUpFirebaseAuth();
    tLocation = LatLng(1, 1);
    tCity = "someCity";
  });

  group("no errors", () {
    setUp(() {
      networkInfoMock.setUpItHasConnection();
      firebaseServiceMock.setUpFirebaseUserId(tUserId);
      firebaseServiceMock
          .setUpFirestoreDocumentData(tUserProfileData.toJsonMap());
      firebaseServiceMock.setUpNumberOfDocumentsInCollectionSnapshot(
          numOfDocs: 3, docId: "undefinedNow");
      when(locationServiceMock.mapLocationToCity(any))
          .thenAnswer((realInvocation) async => tCity);
    });

    //createEvent
    test("should make a call to firebaseFirestore", () async {
      await eventsRepository.createEvent(tFinishedData);
      verify(firebaseServiceMock.firebaseFirestoreMock.collection("events"))
          .called(1);
    });
    //createEvent
    test("should save the event under the city name", () async {
      await eventsRepository.createEvent(tFinishedData);
      verify(firebaseServiceMock.collectionReferenceMock.doc(tCity)).called(1);
    });

    test("should acces user data", () async {
      await eventsRepository.createEvent(tFinishedData);
      verify(firebaseServiceMock.collectionReferenceMock.doc(tUserId))
          .called(1);
    });

    test("should get current id from firebase auth", () async {
      await eventsRepository.createEvent(tFinishedData);
      verify(firebaseServiceMock.firebaseAuthMock.currentUser).called(1);
    });

    test("should return Success", () async {
      final response = await eventsRepository.createEvent(tFinishedData);
      expect(response, Right(Success()));
    });

    //getAllEvents()
    test("should make a call to firebaseFirestore", () async {
      await eventsRepository.getAllEvents(tLocation);
      verify(firebaseServiceMock.firebaseFirestoreMock.collection("events"));
    });
    test("should make a call document  with the name of the good city",
        () async {
      await eventsRepository.getAllEvents(tLocation);
      verify(firebaseServiceMock.collectionReferenceMock.doc(tCity));
    });

    test("should make a call to city_events", () async {
      await eventsRepository.getAllEvents(tLocation);
      verify(firebaseServiceMock.documentReferenceMock
              .collection("city_events"))
          .called(1);
    });

/*     test("should return the list of events", () async {
      firebaseServiceMock.setUpFirestoreDocumentData(tEventModel
          .toJsonMap()); // !! The list that I get back is the same, the type and all the data types.. dunno why it sais they are not eaqual, dafuq
      final response = await eventsRepository.getAllEvents(tLocation);

      expect(
          response,
          Right([
            tEventModel,
            tEventModel,
            tEventModel,
          ]));
    }); */
  });

  group("errors", () {
    //createEvent()
    test("should return network failure when no connection", () async {
      networkInfoMock.setUpNoConnection();
      final response = await eventsRepository.createEvent(tFinishedData);
      expect(response, Left(NetworkFailure()));
    });
    test(
        "should return server failure failure when no data is got from databse when getting user data",
        () async {
      networkInfoMock.setUpItHasConnection();
      firebaseServiceMock.setUpFirestoreDocumentData(null);
      final response = await eventsRepository.createEvent(tFinishedData);
      expect(response, Left(ServerFailure()));
    });
    test(
        "should return server failure when firebase auth return null for current user",
        () async {
      networkInfoMock.setUpItHasConnection();
      firebaseServiceMock.returnNullForCurrentUser();
      final response = await eventsRepository.createEvent(tFinishedData);
      expect(response,
          Left(ServerFailure(message: "Couldnt identify current user.")));
    });
    test("should return server failure when firebase firstore throws error",
        () async {
      networkInfoMock.setUpItHasConnection();
      firebaseServiceMock.setUpFirebaseFirestoreError();
      final response = await eventsRepository.createEvent(tFinishedData);
      expect(response, Left(ServerFailure()));
    });
  });
}

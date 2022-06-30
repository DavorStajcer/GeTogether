import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/core/maps/location_service.dart';
import 'package:get_together_app/core/network.dart/network_info.dart';
import 'package:get_together_app/features/events_overview/data/models/event_model.dart';
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:get_together_app/features/events_overview/domain/repositoires/events_repository.dart';
import 'package:get_together_app/features/make_event/domain/entities/create_event_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventsRepositoryImpl extends EventsRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firebaseFirestore;
  final NetworkInfo networkInfo;
  final LocationService locationService;

  EventsRepositoryImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseStorage? firebaseStorage,
    FirebaseFirestore? firebaseFirestore,
    required LocationService locationService,
    required this.networkInfo,
  })   : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        firebaseStorage = firebaseStorage ?? FirebaseStorage.instance,
        locationService = locationService;

  @override
  Future<Either<Failure, List<Event>>> getAllEvents(
      LatLng currentLocation) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return Left(NetworkFailure());
    try {
      final String? city =
          await locationService.mapLocationToCity(currentLocation);
      if (city == null)
        return Left(
          ServerFailure(
            message:
                "Failed to get your current city. Check your connection or try that again. Sorry :(",
          ),
        );
      final querySnapshot = await firebaseFirestore
          .collection("events")
          .doc(city)
          .collection("city_events")
          .get();
      List<Event> eventsList = [];
      querySnapshot.docs.forEach((queryDocSnapshot) {
        eventsList.add(EventModel.fromJsonMap(
            queryDocSnapshot.id, queryDocSnapshot.data()));
      });
      return Right(eventsList);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> createEvent(
      CreateEventData createEventData) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return Left(NetworkFailure());
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null)
      return Left(ServerFailure(message: "Couldnt identify current user."));
    try {
      final currentUserId = currentUser.uid;
      final docSnapshot =
          await firebaseFirestore.collection("users").doc(currentUserId).get();

      if (docSnapshot.data() == null) return Left(ServerFailure());
      if (!docSnapshot.data()!.containsKey("rating") ||
          !docSnapshot.data()!.containsKey("username") ||
          !docSnapshot.data()!.containsKey("imageUrl"))
        return Left(ServerFailure());
      final eventModel =
          _mapDocSnapshotToEvent(docSnapshot, createEventData, currentUserId);
      final String? city =
          await locationService.mapLocationToCity(createEventData.location);
      if (city == null)
        return Left(
          ServerFailure(
              message:
                  "Failed to get your current city. Check your connection or try that again. Sorry :("),
        );

      await firebaseFirestore
          .collection("events")
          .doc(city)
          .collection("city_events")
          .add(eventModel.toJsonMap());
      return Right(Success());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  EventModel _mapDocSnapshotToEvent(
    DocumentSnapshot docSnapshot,
    CreateEventData createEventData,
    String currentUserId,
  ) {
    final int adminRating = docSnapshot.data()!["rating"];
    final String adminUsername = docSnapshot.data()!["username"];
    final String adminImageUrl = docSnapshot.data()!["imageUrl"];
    final event = EventModel(
        eventId: "undefinedNow",
        eventType: createEventData.type,
        dateString: createEventData.dateString!,
        timeString: createEventData.timeString!,
        location: createEventData.location,
        adminId: currentUserId,
        adminUsername: adminUsername,
        adminImageUrl: adminImageUrl,
        adminRating: adminRating,
        numberOfPeople: 1,
        eventName: createEventData.eventName,
        description: createEventData.description,
        peopleImageUrls: {});
    return event;
  }
}

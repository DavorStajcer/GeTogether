import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_together_app/core/error/exceptions.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/maps/location_service.dart';
import 'package:get_together_app/core/network.dart/network_info.dart';
import 'package:get_together_app/features/events_overview/data/models/event_model.dart';
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';
import 'package:get_together_app/features/notifications_overview/data/models/notification_model.dart';
import 'package:get_together_app/features/notifications_overview/presentation/widgets/join_request.dart';
import 'package:get_together_app/features/single_event_overview/domain/repositoires/user_events_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum UserJoinStatus { joined, requested, not }

class UserEventsRepositoryImpl extends UserEventsRepository {
  final NetworkInfo networkInfo;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final LocationService locationService;
  UserEventsRepositoryImpl({
    required this.networkInfo,
    required this.locationService,
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firebaseFirestore,
  })  : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<Failure, Success>> removeUserFromEvent(Event event) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return Left(NetworkFailure());
    final User? currentUser = firebaseAuth.currentUser;
    if (currentUser == null)
      return Left(ServerFailure(message: "Problem identifyng current user"));
    final currentUserId = currentUser.uid;
    try {
      final userDocSnapshot =
          await firebaseFirestore.collection("users").doc(currentUserId).get();
      final userData = userDocSnapshot.data();
      if (userData == null)
        return Left(
          ServerFailure(
            message:
                "Not able to get your user data at the moment. Please try again later.",
          ),
        );
      final city = await locationService.mapLocationToCity(event.location);
      if (city == null) return Left(ServerFailure(message: "Location problem"));
      await firebaseFirestore
          .collection("events")
          .doc(city)
          .collection("city_events")
          .doc(event.eventId)
          .update({"peopleImageUrls.$currentUserId": FieldValue.delete()});
      return Right(Success());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> declineJoinRequest(
      JoinEventNotificationModel notification) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return Left(NetworkFailure());
    final User? currentUser = firebaseAuth.currentUser;
    if (currentUser == null)
      return Left(ServerFailure(message: "Problem identifyng current user"));
    final currentUserId = currentUser.uid;
    try {
      await firebaseFirestore
          .collection("users")
          .doc(currentUserId)
          .collection("user_notifications")
          .doc(notification.notificationId)
          .update({
        "resolvedStatus": NotificationResolved.rejected.index,
      });
      return Right(Success());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> joinUserToEvent(
      JoinEventNotificationModel notification) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return Left(NetworkFailure());
    final User? currentUser = firebaseAuth.currentUser;
    if (currentUser == null)
      return Left(ServerFailure(message: "Problem identifyng current user"));
    final currentUserId = currentUser.uid;
    try {
      await firebaseFirestore
          .collection("events")
          .doc(notification.eventCity)
          .collection("city_events")
          .doc(notification.eventId)
          .update({
        "peopleImageUrls.${notification.senderId}": notification.senderImageUrl
      });
      await firebaseFirestore
          .collection("users")
          .doc(currentUserId)
          .collection("user_notifications")
          .doc(notification.notificationId)
          .update({
        "resolvedStatus": NotificationResolved.accepted.index,
      });
      return Right(Success());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserJoinStatus>> checkIsUserJoined(Event event) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return Left(NetworkFailure());
    final User? currentUser = firebaseAuth.currentUser;
    if (currentUser == null)
      return Left(ServerFailure(message: "Problem identifyng current user"));
    final currentUserId = currentUser.uid;
    final String? eventCity =
        await locationService.mapLocationToCity(event.location);
    if (eventCity == null)
      return Left(ServerFailure(message: "Problem identifyng event location"));
    try {
      final eventCityRef = firebaseFirestore
          .collection("users")
          .doc(currentUserId)
          .collection("user_events")
          .doc(eventCity);
      final dataSnapshot = await eventCityRef.get();
      final data = dataSnapshot.data();

      if (data == null) {
        return Right(UserJoinStatus.not);
      }
      final listOfUserJoinedEvents = List.from(data["eventIds"]);
      UserJoinStatus isUserJoined = UserJoinStatus.not;
      listOfUserJoinedEvents.forEach((userEventId) {
        if (userEventId == event.eventId) isUserJoined = UserJoinStatus.joined;
      });
      if (isUserJoined != UserJoinStatus.joined)
        isUserJoined = await _isJoinRequested(currentUserId, event.eventId);
      return Right(isUserJoined);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  Future<UserJoinStatus> _isJoinRequested(String userId, String eventId) async {
    final requestDocSnapshot = await firebaseFirestore
        .collection("users")
        .doc(userId)
        .collection("sent_requests")
        .doc(eventId)
        .get();
    if (requestDocSnapshot.exists)
      return UserJoinStatus.requested;
    else
      return UserJoinStatus.not;
  }

  @override
  Future<Either<Failure, List<Event>>> getAllUserEvents() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return Left(NetworkFailure());
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) return Left(ServerFailure());
    final currentUserId = currentUser.uid;
    try {
      final List<String> userEventIds =
          await fetchAllEventIdsForCurrentUser(currentUserId);
      final events = await _mapEventIdsToEvents(userEventIds);
      return Right(events);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAllUserEventIds() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return Left(NetworkFailure());
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) return Left(ServerFailure());
    final currentUserId = currentUser.uid;
    try {
      final List<String> userEventIds =
          await fetchAllEventIdsForCurrentUser(currentUserId);
      return Right(userEventIds);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  Future<List<String>> fetchAllEventIdsForCurrentUser(
      String currentUserId) async {
    final userEventsSnapshot = await firebaseFirestore
        .collection("users")
        .doc(currentUserId)
        .collection("user_events")
        .get();

    final List<String> userEventIds = [];
    userEventsSnapshot.docs.forEach((city) {
      final docData = city.data();
      final adminIds = docData["adminIds"] as List<dynamic>;
      final memberIds = docData["eventIds"] as List<dynamic>;
      adminIds.forEach((eventId) {
        userEventIds.add(eventId);
      });
      memberIds.forEach((eventId) {
        userEventIds.add(eventId);
      });
    });
    return userEventIds;
  }

  Future<List<Event>> _mapEventIdsToEvents(List<String> eventIds) async {
    final response = await locationService.getLocation();
    final currentLocation = response.fold<LatLng>((l) {
      throw (ServerException());
    }, (position) => LatLng(position.latitude, position.longitude));
    final String? eventCity =
        await locationService.mapLocationToCity(currentLocation);
    if (eventCity == null) throw (ServerException());
    final List<Event> userEvents = [];
    for (var eventId in eventIds) {
      final docSnapshot = await firebaseFirestore
          .collection("events")
          .doc(eventCity)
          .collection("city_events")
          .doc(eventId)
          .get();
      if (docSnapshot.exists) {
        final docData = docSnapshot.data();
        if (docData != null)
          userEvents.add(EventModel.fromJsonMap(eventId, docData));
      }
    }
    if (userEvents.length != eventIds.length) {
      final otherEvents = await _findEventsFromOtherCities(
          eventIds, eventCity, userEvents.length, eventIds.length);
      userEvents.addAll(otherEvents);
    }
    return userEvents;
  }

  Future<List<Event>> _findEventsFromOtherCities(
      List<String> userEventIds,
      String allreadySearchedCity,
      int gotEventsListSize,
      int allEventsSize) async {
    final eventsNumber = gotEventsListSize;
    final List<Event> moreUserEvents = [];
    final querySnapshot = await firebaseFirestore.collection("events").get();

    querySnapshot.docs.forEach((eventCity) async {
      if (eventsNumber == allEventsSize) return;
      if (eventCity.id == allreadySearchedCity) return;
      final cityEvents = await firebaseFirestore
          .collection("events")
          .doc(eventCity.id)
          .collection("city_events")
          .get();
      cityEvents.docs.forEach((eventDoc) {
        if (!userEventIds.contains(eventDoc.id)) return;
        final eventData = eventDoc.data();
        moreUserEvents.add(EventModel.fromJsonMap(eventDoc.id, eventData));
      });
    });
    return moreUserEvents;
  }

  /*  @override
  Future<Either<Failure, List<Event>>> getAllUserAdminEvents() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return Left(NetworkFailure());
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) return Left(ServerFailure());
    final currentUserId = currentUser.uid;
    try {
      final userEventsSnapshot = await firebaseFirestore
          .collection("users")
          .doc(currentUserId)
          .collection("user_events")
          .get();
      final List<String> allUserAdminEventIds = [];
      userEventsSnapshot.docs.forEach((city) {
        final docData = city.data();
        final adminIds = docData["adminIds"] as List<dynamic>;
        adminIds.forEach((eventId) {
          allUserAdminEventIds.add(eventId);
        });
      });
      final List<Event> userAdminEvents = [];
      allUserAdminEventIds.forEach((eventId) {

      });
      return Right(userAdminEvents);
    } catch (e) {
      return Left(ServerFailure());
    }
  } */
}

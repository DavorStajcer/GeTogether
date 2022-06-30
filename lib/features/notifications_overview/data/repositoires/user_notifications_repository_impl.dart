import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_together_app/core/error/exceptions.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/maps/location_service.dart';
import 'package:get_together_app/core/network.dart/network_info.dart';
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';
import 'package:get_together_app/features/notifications_overview/data/models/notification_model.dart';
import 'package:get_together_app/features/notifications_overview/domain/entities/notification.dart';
import 'package:get_together_app/features/notifications_overview/domain/repositories/user_notifications_repository.dart';
import 'package:get_together_app/features/notifications_overview/presentation/widgets/join_request.dart';

class UserNotificationsRepositoryImpl extends UserNotificationsRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final NetworkInfo networkInfo;
  final LocationService locationService;
  UserNotificationsRepositoryImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firebaseFirestore,
    required NetworkInfo networkInfo,
    required this.locationService,
  })   : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        networkInfo = networkInfo;

  Query? lastNotificationsQuery;
  DocumentSnapshot? lastDocSnapshot;

  @override
  Future<Either<Failure, Success>> sendJoinRequest(
    Event event,
  ) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return Left(NetworkFailure());
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null)
      return Left(ServerFailure(message: "Coludnt identify current user"));
    try {
      final currentUid = currentUser.uid;
      final userSnapshot =
          await firebaseFirestore.collection("users").doc(currentUid).get();
      final userData = userSnapshot.data();
      if (userData == null) throw ServerException();
      final userImageUrl = userData["imageUrl"];
      final username = userData["username"];
      //Add event name to parameter of event
      final String content =
          "$username wants to join your event \"${event.eventName}\"";
      final city = await locationService.mapLocationToCity(event.location);
      if (city == null)
        return Left(ServerFailure(message: "Location problem."));
      final JoinEventNotificationModel joinEventNotification =
          JoinEventNotificationModel(
        eventId: event.eventId,
        senderId: currentUid,
        senderImageUrl: userImageUrl,
        city: city,
        content: content,
        eventName: event.eventName,
        resolvedStatus: NotificationResolved.pending,
      );
      await firebaseFirestore
          .collection("users")
          .doc(event.adminId)
          .collection("user_notifications")
          .add(joinEventNotification.toJsonMap(
            NotificationType.join,
            FieldValue.serverTimestamp(),
          ));

      return Right(Success());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<EventInfoNotification>>>
      getNextNotifications() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return Left(NetworkFailure());
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null)
      return Left(ServerFailure(message: "Coludnt identify current user"));
    try {
      final currentUid = currentUser.uid;
      final notifications = await _requestNextNotifications(currentUid);
      return Right(notifications);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  Future<List<EventInfoNotification>> _requestNextNotifications(
      String currentUid) async {
    if (lastNotificationsQuery == null)
      return _getInitialNotifications(currentUid);
    else
      return _getMoreNotifications(currentUid);
  }

  Future<List<EventInfoNotification>> _getInitialNotifications(
      String currentUid) async {
    lastNotificationsQuery = firebaseFirestore
        .collection("users")
        .doc(currentUid)
        .collection("user_notifications")
        .orderBy("timestamp", descending: true)
        .limit(15);
    final querySnapshot = await lastNotificationsQuery!.get();
    if (querySnapshot.docs.isEmpty) return [];
    lastDocSnapshot = querySnapshot.docs.last;
    final List<EventInfoNotification> notifications = [];
    querySnapshot.docs.forEach((doc) {
      final docData = doc.data();
      final notificationType = _mapNotificationIndexToType(docData["type"]);
      late EventInfoNotification notification;
      if (notificationType == null) throw ServerException();
      if (notificationType == NotificationType.event_info)
        notification = EventInfoNotificationModel.fromJsonMap(docData);
      else if (notificationType == NotificationType.join)
        notification = JoinEventNotificationModel.fromJsonMap(doc.id, docData);
      else
        notification = LeaveEventInfoNotificationModel.fromJsonMap(docData);
      notifications.add(notification);
    });

    return notifications;
  }

  Future<List<EventInfoNotification>> _getMoreNotifications(
      String currentUid) async {
    lastNotificationsQuery =
        lastNotificationsQuery!.startAfterDocument(lastDocSnapshot!).limit(10);
    final querySnapshot = await lastNotificationsQuery!.get();
    if (querySnapshot.docs.isEmpty) return [];
    lastDocSnapshot = querySnapshot.docs.last;
    final List<EventInfoNotification> notifications = [];
    querySnapshot.docs.forEach((doc) {
      final docData = doc.data();
      final notificationType = _mapNotificationIndexToType(docData["type"]);
      late EventInfoNotification notification;
      if (notificationType == null) throw ServerException();
      if (notificationType == NotificationType.event_info)
        notification = EventInfoNotificationModel.fromJsonMap(docData);
      else if (notificationType == NotificationType.join)
        notification = JoinEventNotificationModel.fromJsonMap(doc.id, docData);
      else
        notification = LeaveEventInfoNotificationModel.fromJsonMap(docData);
      notifications.add(notification);
    });
    return notifications;
  }

  NotificationType? _mapNotificationIndexToType(int index) {
    switch (index) {
      case 0:
        return NotificationType.event_info;
      case 1:
        return NotificationType.join;
      case 2:
        return NotificationType.leave;
      default:
        return null;
    }
  }

  @override
  Future<void> resetLastFetchedNotification() async {
    lastDocSnapshot = null;
    lastNotificationsQuery = null;
  }
}

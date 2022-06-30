import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/network.dart/network_info.dart';
import 'package:get_together_app/features/home/domain/repositories/live_notifications_and_messages_repository.dart';

class LiveNotificationsAndMessagesRepositoryImpl
    extends LiveNotificationsAndMessagesRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final NetworkInfo networkInfo;

  LiveNotificationsAndMessagesRepositoryImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firebaseFirestore,
    required this.networkInfo,
  })   : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<int> listenToNewNotificationsNum() {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) return Stream<int>.empty();
    return firebaseFirestore
        .collection("users")
        .doc(currentUser.uid)
        .collection("unread_data")
        .doc("notifications")
        .snapshots()
        .map((docSnapshot) {
      if (!docSnapshot.exists) return 0;
      final docData = docSnapshot.data();
      if (docData == null) return 0;
      return docData["unreadNotifications"];
    });
  }

  @override
  Stream<int> listenToNewMessageNum() {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) return Stream<int>.empty();
    return firebaseFirestore
        .collection("users")
        .doc(currentUser.uid)
        .collection("unread_data")
        .doc("chats")
        .snapshots()
        .map((docSnapshot) {
      if (!docSnapshot.exists) return 0;
      final docData = docSnapshot.data();
      if (docData == null) return 0;
      if (docData["number"] == null) return 0;
      return docData["number"];
    });
  }

  @override
  Future<Either<Failure, Success>> resetUnreadNotifications() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return Left(NetworkFailure());
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) return Left(ServerFailure());
    try {
      await firebaseFirestore
          .collection("users")
          .doc(currentUser.uid)
          .collection("unread_data")
          .doc("notifications")
          .update({
        "unreadNotifications": 0,
      });
      return Right(Success());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> resetUnreadMessages() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return Left(NetworkFailure());
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) return Left(ServerFailure());
    try {
      await firebaseFirestore
          .collection("users")
          .doc(currentUser.uid)
          .collection("unread_data")
          .doc("chats")
          .update({
        "newlyMessagedChats": FieldValue.delete(),
        "number": 0,
      });
      return Right(Success());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}

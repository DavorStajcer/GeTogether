import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/error/success.dart';

abstract class LiveNotificationsAndMessagesRepository {
  Stream<int> listenToNewMessageNum();
  Stream<int> listenToNewNotificationsNum();
  Future<Either<Failure, Success>> resetUnreadNotifications();
  Future<Either<Failure, Success>> resetUnreadMessages();
}

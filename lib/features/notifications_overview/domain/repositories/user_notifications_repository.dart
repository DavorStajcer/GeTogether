import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';
import 'package:get_together_app/features/notifications_overview/domain/entities/notification.dart';

abstract class UserNotificationsRepository {
  Future<Either<Failure, Success>> sendJoinRequest(Event event);
  Future<Either<Failure, List<EventInfoNotification>>> getNextNotifications();
  Future<void> resetLastFetchedNotification();
}

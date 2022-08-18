import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';
import 'package:get_together_app/features/notifications_overview/data/models/notification_model.dart';
import 'package:get_together_app/features/single_event_overview/data/repositoires/user_events_repository_impl.dart';

abstract class UserEventsRepository {
  Future<Either<Failure, UserJoinStatus>> checkIsUserJoined(Event event);
  Future<Either<Failure, Success>> joinUserToEvent(
      JoinEventNotificationModel notification);
  Future<Either<Failure, Success>> removeUserFromEvent(Event event);
  Future<Either<Failure, Success>> declineJoinRequest(
      JoinEventNotificationModel notification);
  Future<Either<Failure, List<Event>>> getAllUserEvents();
  Future<Either<Failure, List<String>>> getAllUserEventIds();
}

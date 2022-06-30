import 'package:get_together_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/features/notifications_overview/domain/entities/notification.dart';
import 'package:get_together_app/features/notifications_overview/domain/repositories/user_notifications_repository.dart';

class GetUserNotifications
    extends Usecase<List<EventInfoNotification>, NoParameters> {
  final UserNotificationsRepository userNotificationsRepository;
  GetUserNotifications({required this.userNotificationsRepository});

  @override
  Future<Either<Failure, List<EventInfoNotification>>> call(
      NoParameters param) async {
    return await userNotificationsRepository.getNextNotifications();
  }

  Future<void> resetNotificationFetching() async {
    await userNotificationsRepository.resetLastFetchedNotification();
  }
}

import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/features/home/domain/repositories/live_notifications_and_messages_repository.dart';

class ResetUnreadNotifications extends Usecase<Success, NoParameters> {
  LiveNotificationsAndMessagesRepository liveNotificationsAndMessagesRepository;
  ResetUnreadNotifications(this.liveNotificationsAndMessagesRepository);
  @override
  Future<Either<Failure, Success>> call(NoParameters param) async {
    return await liveNotificationsAndMessagesRepository
        .resetUnreadNotifications();
  }
}

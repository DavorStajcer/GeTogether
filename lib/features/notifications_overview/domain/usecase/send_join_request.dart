import 'package:get_together_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';
import 'package:get_together_app/features/notifications_overview/domain/repositories/user_notifications_repository.dart';

class SendJoinRequest extends Usecase<Success, Event> {
  UserNotificationsRepository userNotificationsRepository;

  SendJoinRequest(this.userNotificationsRepository);

  @override
  Future<Either<Failure, Success>> call(Event event) async {
    return await userNotificationsRepository.sendJoinRequest(event);
  }
}

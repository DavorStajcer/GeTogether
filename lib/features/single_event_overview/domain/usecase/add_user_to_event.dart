import 'package:get_together_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/features/notifications_overview/data/models/notification_model.dart';
import 'package:get_together_app/features/single_event_overview/domain/repositoires/user_events_repository.dart';

class AddUserToEvent extends Usecase<Success, JoinEventNotificationModel> {
  final UserEventsRepository userEventsRepository;
  AddUserToEvent({required this.userEventsRepository});

  @override
  Future<Either<Failure, Success>> call(
      JoinEventNotificationModel notification) async {
    return await userEventsRepository.joinUserToEvent(notification);
  }
}

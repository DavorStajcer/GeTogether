import 'package:get_together_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/features/single_event_overview/domain/repositoires/user_events_repository.dart';

class GetAllUserEventIds extends Usecase<List<String>, NoParameters> {
  final UserEventsRepository userEventsRepository;
  GetAllUserEventIds(this.userEventsRepository);

  @override
  Future<Either<Failure, List<String>>> call(NoParameters param) async =>
      await userEventsRepository.getAllUserEventIds();
}

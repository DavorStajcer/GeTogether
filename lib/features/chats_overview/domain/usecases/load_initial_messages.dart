import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/features/chats_overview/domain/enitites/message.dart';
import 'package:get_together_app/features/chats_overview/domain/repositories/event_messages_repository.dart';

class LoadInitalMessages extends Usecase<List<Message>, String> {
  final EventMessagesRepository eventMessagesRepository;
  LoadInitalMessages(this.eventMessagesRepository);

  @override
  Future<Either<Failure, List<Message>>> call(String eventId) async {
    return await eventMessagesRepository.loadInitMessages(eventId);
  }
}

import 'package:get_together_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/features/chats_overview/domain/repositories/event_messages_repository.dart';

class SendMessage extends Usecase<Success, SendMessagePrameters> {
  final EventMessagesRepository eventMessagesRepository;
  SendMessage(this.eventMessagesRepository);

  @override
  Future<Either<Failure, Success>> call(SendMessagePrameters param) async {
    return await eventMessagesRepository.addMessage(
      param.eventId,
      param.eventCity,
      param.message,
    );
  }
}

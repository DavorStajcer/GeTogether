import 'package:get_together_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/features/chats_overview/domain/enitites/message.dart';
import 'package:get_together_app/features/chats_overview/domain/repositories/event_messages_repository.dart';

class LoadNewPage extends Usecase<List<Message>, String> {
  EventMessagesRepository eventMessagesRepository;
  LoadNewPage(this.eventMessagesRepository);

  @override
  Future<Either<Failure, List<Message>>> call(String eventId) async {
    return eventMessagesRepository.loadNextPage(eventId);
  }

  bool canLoadMorePages() {
    return eventMessagesRepository.isAableToLoadMorePages();
  }
}

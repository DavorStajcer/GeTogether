import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/features/chats_overview/domain/enitites/message.dart';

abstract class EventMessagesRepository {
  //Stream<DocumentSnapshot> listenToMessageSnippetChanges(String eventId);
  Stream<Either<Failure, List<Message>>> listenToChatMessages(String eventId);
  Future<void> stopListeningToChatMessages();
  Future<Either<Failure, Success>> addMessage(
      String eventId, String eventCity, String message);
  Future<Either<Failure, List<Message>>> loadNextPage(String eventId);
  Future<Either<Failure, List<Message>>> loadInitMessages(String eventId);
  bool isAableToLoadMorePages();
}

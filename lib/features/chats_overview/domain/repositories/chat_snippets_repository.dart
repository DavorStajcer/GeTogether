import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/features/chats_overview/domain/enitites/chat_snippet.dart';

abstract class ChatSnippetsReposiotry {
  Stream<ChatSnippet> listenToChatSnippetsChanges(
    List<ChatSnippet> chatSnippets,
  );
  Future<void> markChatSnippetAsRead(
    String userChatId,
  );
  Future<void> stopListeningToChatSnippetChanges();
  Future<Either<Failure, List<ChatSnippet>>> getInitialChatSnippets(
    List<String> userChatIds,
  );
}

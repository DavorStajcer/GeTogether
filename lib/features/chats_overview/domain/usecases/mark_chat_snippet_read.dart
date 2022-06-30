import 'package:get_together_app/features/chats_overview/domain/repositories/chat_snippets_repository.dart';

class MarkChatSnippetRead {
  final ChatSnippetsReposiotry chatSnippetsReposiotry;
  MarkChatSnippetRead(this.chatSnippetsReposiotry);

  Future<void> call(String chatId) async {
    await chatSnippetsReposiotry.markChatSnippetAsRead(chatId);
  }
}

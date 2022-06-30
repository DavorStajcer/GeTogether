import 'package:get_together_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/core/util/chat_snippet_orginizer.dart';
import 'package:get_together_app/features/chats_overview/domain/enitites/chat_snippet.dart';
import 'package:get_together_app/features/chats_overview/domain/repositories/chat_snippets_repository.dart';

class GetInitialChatSnippets extends Usecase<List<ChatSnippet>, List<String>> {
  ChatSnippetsReposiotry chatSnippetsReposiotry;
  GetInitialChatSnippets(this.chatSnippetsReposiotry);

  @override
  Future<Either<Failure, List<ChatSnippet>>> call(
      List<String> userChatIds) async {
    final response =
        await chatSnippetsReposiotry.getInitialChatSnippets(userChatIds);
    return response.fold<Either<Failure, List<ChatSnippet>>>(
      (failure) => Left(failure),
      (chatSnippets) =>
          Right(ChatSnippetOrganizer.orderChatSnippetsByDate(chatSnippets)),
    );
  }
}

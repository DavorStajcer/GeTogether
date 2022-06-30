/* //@dart=2.6
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/features/chats_overview/domain/enitites/chat_snippet.dart';
import 'package:get_together_app/features/chats_overview/domain/usecases/listen_to_chat_snippets_change.dart';
import 'package:get_together_app/features/chats_overview/presentation/bloc/message_snippet_bloc/chat_snippet_bloc.dart';
import 'package:mockito/mockito.dart';

class ListenToLastMessageSnippetMock extends Mock
    implements ListenToLastMessageSnippet {}

void main() {
  ListenToLastMessageSnippetMock listenToLastMessageSnippetMock;
  ChatSnippetBloc chatSnippetBloc;
  String tEventId;
  ChatSnippet tChatSnippet;

  setUp(() {
    listenToLastMessageSnippetMock = ListenToLastMessageSnippetMock();
    chatSnippetBloc = ChatSnippetBloc(
        listenToLastMessageSnippet: listenToLastMessageSnippetMock);
    tEventId = "tEventId";
    tChatSnippet = ChatSnippet(
        eventId: tEventId,
        eventName: "tEventName",
        adminImageUrl: "adminImageUrl",
        lastMessageDate: DateTime(2021),
        lastMessageSnippet: "lastMessageSnippet");
  });

  test("inital state should be ChatSnippetLoading", () {
    expect(chatSnippetBloc.state, ChatSnippetLoading());
  });

  group(
    "no errors",
    () {
      blocTest(
        "should make a call to usecase when screen is initalized",
        build: () {
          when(listenToLastMessageSnippetMock.call(chatSnippetBloc, tEventId))
              .thenAnswer((realInvocation) {});
          return chatSnippetBloc;
        },
        act: (bloc) => (bloc as ChatSnippetBloc).add(
          ChatsScreenInitialized(tEventId),
        ),
        verify: (bloc) => verify(
          listenToLastMessageSnippetMock(chatSnippetBloc, tEventId),
        ),
      );

      blocTest(
        "should emit chat screen loaded with chat snippet",
        build: () {
          when(listenToLastMessageSnippetMock.call(chatSnippetBloc, tEventId))
              .thenAnswer((realInvocation) {});
          return chatSnippetBloc;
        },
        act: (bloc) => (bloc as ChatSnippetBloc).add(
          ChatSnippetChnaged(
            Right(tChatSnippet),
          ),
        ),
        expect: () => [ChatSnippetLoaded(tChatSnippet)],
      );
    },
  );

  group("errors", () {
    blocTest(
      "should emit chat server failure on server failure",
      build: () {
        when(listenToLastMessageSnippetMock.call(chatSnippetBloc, tEventId))
            .thenAnswer((realInvocation) {});
        return chatSnippetBloc;
      },
      act: (bloc) => (bloc as ChatSnippetBloc).add(
        ChatSnippetChnaged(
          Left(ServerFailure(message: "message")),
        ),
      ),
      expect: () => [ChatSnippetServerFailure("message")],
    );

    blocTest(
      "should emit chat network failure on network failure",
      build: () {
        when(listenToLastMessageSnippetMock.call(chatSnippetBloc, tEventId))
            .thenAnswer((realInvocation) {});
        return chatSnippetBloc;
      },
      act: (bloc) => (bloc as ChatSnippetBloc).add(
        ChatSnippetChnaged(
          Left(NetworkFailure(message: "message")),
        ),
      ),
      expect: () => [ChatSnippetNetworkFailure("message")],
    );
  });
}
 */
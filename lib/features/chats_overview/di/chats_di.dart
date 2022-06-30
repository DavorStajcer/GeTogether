import 'package:get_together_app/features/authentication/di/authentication_di.dart';
import 'package:get_together_app/features/chats_overview/data/repositories/chat_snippets_repository_impl.dart';
import 'package:get_together_app/features/chats_overview/data/repositories/event_messages_repository_impl.dart';
import 'package:get_together_app/features/chats_overview/domain/repositories/chat_snippets_repository.dart';
import 'package:get_together_app/features/chats_overview/domain/repositories/event_messages_repository.dart';
import 'package:get_together_app/features/chats_overview/domain/usecases/get_all_user_event_ids.dart';
import 'package:get_together_app/features/chats_overview/domain/usecases/get_inital_chat_snippets.dart';
import 'package:get_together_app/features/chats_overview/domain/usecases/listen_to_chat_snippets_change.dart';
import 'package:get_together_app/features/chats_overview/domain/usecases/listen_to_messages.dart';
import 'package:get_together_app/features/chats_overview/domain/usecases/load_initial_messages.dart';
import 'package:get_together_app/features/chats_overview/domain/usecases/load_new_page.dart';
import 'package:get_together_app/features/chats_overview/domain/usecases/mark_chat_snippet_read.dart';
import 'package:get_together_app/features/chats_overview/domain/usecases/reset_unread_chat_messages.dart';
import 'package:get_together_app/features/chats_overview/domain/usecases/send_message.dart';
import 'package:get_together_app/features/chats_overview/presentation/bloc/chat_messages_bloc/chat_messages_bloc.dart';
import 'package:get_together_app/features/chats_overview/presentation/bloc/chat_snippets_bloc/chat_snippet_bloc.dart';
import 'package:get_together_app/features/chats_overview/presentation/bloc/chats_overivew_cubit/chats_overview_cubit.dart';
import 'package:get_together_app/features/chats_overview/presentation/bloc/send_message_cubit/send_message_cubit.dart';

void initChatDi() {
  getIt.registerSingleton<EventMessagesRepository>(
      EventMessageRepositoryImpl(networkInfo: getIt()));
  getIt.registerSingleton(GetAllUserEventIds(getIt()));
  getIt.registerSingleton<ChatSnippetsReposiotry>(
      ChatSnippetsRepositoryImpl(networkInfo: getIt()));
  getIt.registerSingleton(ListenToChatSnippetsChange(getIt()));
  getIt.registerSingleton(GetInitialChatSnippets(getIt()));
  getIt.registerSingleton(MarkChatSnippetRead(getIt()));
  getIt.registerSingleton(ListenToMessages(getIt()));
  getIt.registerSingleton(SendMessage(getIt()));
  getIt.registerSingleton(LoadNewPage(getIt()));
  getIt.registerSingleton(LoadInitalMessages(getIt()));
  getIt.registerFactory(() => ChatsOverviewCubit(getIt()));
  getIt.registerSingleton(ResetUnreadChatMessages(getIt()));
  getIt.registerFactory(() => ChatSnippetsBloc(
        getInitialChatSnippets: getIt(),
        listenToChatSnippetsChange: getIt(),
      ));
  getIt.registerFactory(() => ChatMessagesBloc(
        listenToMessages: getIt(),
        loadInitalMessages: getIt(),
        resetUnreadChatMessages: getIt(),
        markChatSnippetRead: getIt(),
        loadNewPage: getIt(),
      ));
  getIt.registerFactory(() => SendMessageCubit(getIt()));
}

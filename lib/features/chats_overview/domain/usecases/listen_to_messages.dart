import 'package:get_together_app/features/chats_overview/domain/repositories/event_messages_repository.dart';
import 'package:get_together_app/features/chats_overview/presentation/bloc/chat_messages_bloc/chat_messages_bloc.dart';

class ListenToMessages {
  final EventMessagesRepository eventMessagesRepository;
  ListenToMessages(this.eventMessagesRepository);

  void call(ChatMessagesBloc bloc, String eventId) {
    eventMessagesRepository.listenToChatMessages(eventId).listen((response) {
      bloc.add(MessagesAdded(response));
    });
  }

  Future<void> stop() async {
    await eventMessagesRepository.stopListeningToChatMessages();
  }
}

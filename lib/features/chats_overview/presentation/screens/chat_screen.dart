import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/features/authentication/di/authentication_di.dart';

import 'package:get_together_app/features/chats_overview/domain/enitites/chat_snippet.dart';
import 'package:get_together_app/features/chats_overview/presentation/bloc/chat_messages_bloc/chat_messages_bloc.dart';
import 'package:get_together_app/features/chats_overview/presentation/bloc/send_message_cubit/send_message_cubit.dart';
import 'package:get_together_app/features/chats_overview/presentation/widgets/chat_messages.dart';
import 'package:get_together_app/features/chats_overview/presentation/widgets/send_message.dart';

class ChatScreen extends StatelessWidget {
  static const route = "/chat_screen";
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatSnippet =
        ModalRoute.of(context)!.settings.arguments as ChatSnippet;
    final appBar = AppBar(
      title: Text(chatSnippet.eventName),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatMessagesBloc>(
          create: (context) => getIt<ChatMessagesBloc>(),
        ),
        BlocProvider<SendMessageCubit>(
          create: (context) => getIt<SendMessageCubit>(),
        ),
      ],
      child: Scaffold(
        appBar: appBar,
        body: Container(
          color: Color.fromRGBO(237, 231, 246, 1),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.bottomCenter,
                  child: ChatMessages(chatSnippet.eventId),
                ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                padding: EdgeInsets.only(left: 15),
                child: SendMessage(
                  eventId: chatSnippet.eventId,
                  eventCity: chatSnippet.eventCity,
                  eventName: chatSnippet.eventName,
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
/*

  */
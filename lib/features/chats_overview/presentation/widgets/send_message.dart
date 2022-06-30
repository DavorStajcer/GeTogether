import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/features/chats_overview/presentation/bloc/chat_messages_bloc/chat_messages_bloc.dart';
import 'package:get_together_app/features/chats_overview/presentation/bloc/send_message_cubit/send_message_cubit.dart';

class SendMessage extends StatefulWidget {
  final String eventId;
  final String eventName;
  final String eventCity;
  const SendMessage({
    required this.eventId,
    required this.eventCity,
    required this.eventName,
    Key? key,
  }) : super(key: key);

  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  TextEditingController _messageController = TextEditingController();

  InputBorder _buildInputPorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(color: Colors.white, style: BorderStyle.solid),
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatMessagesBloc, ChatMessagesState>(
      builder: (context, state) {
        if (state is ChatMessagesFailure || state is ChatMessagesLoading)
          return Container(
            width: double.infinity,
            height: double.infinity,
          );
        return BlocListener<SendMessageCubit, SendMessageState>(
          listener: (context, state) {
            if (state is SendMessageFailure)
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Message not send.")));
          },
          child: Row(
            children: [
              Flexible(
                flex: 7,
                child: TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: "Message",
                    hintStyle: TextStyle(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                    ),
                    focusedBorder: _buildInputPorder(),
                    enabledBorder: _buildInputPorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: IconButton(
                    color: Theme.of(context).primaryColor,
                    icon: Icon(Icons.send),
                    onPressed: () {
                      BlocProvider.of<SendMessageCubit>(context)
                          .sendNewMessage(SendMessagePrameters(
                        eventId: widget.eventId,
                        eventCity: widget.eventCity,
                        message: _messageController.value.text,
                      ));
                      _messageController.text = "";
                    },
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/core/widgets/network_error.dart';
import 'package:get_together_app/core/widgets/server_error.dart';
import 'package:get_together_app/features/chats_overview/presentation/bloc/chat_messages_bloc/chat_messages_bloc.dart';

enum Sender { currentUser, other }

class ChatMessages extends StatefulWidget {
  final String eventId;
  const ChatMessages(this.eventId, {Key? key}) : super(key: key);

  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  late ChatMessagesBloc _chatMessagesBloc;
  late ScrollController _scrollController;
  final _centerKey = UniqueKey();

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _chatMessagesBloc = BlocProvider.of<ChatMessagesBloc>(context)
      ..add(ChatMessagesScreenInitialized(widget.eventId));
    super.initState();
  }

  @override
  void dispose() {
    _chatMessagesBloc.add(LeavingChatScreen(widget.eventId));
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent + 30 &&
        !_scrollController.position.outOfRange) {
      // log("SCROLLED TO TOP");
      _chatMessagesBloc.add(MessagesScrolledToTop(widget.eventId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatMessagesBloc, ChatMessagesState>(
      listener: (context, state) {
        if (state is NewPageAdded) _chatMessagesBloc.add(NewPageLoaded());
        if (state is InitialMessagesLoaded)
          _chatMessagesBloc.add(MessagesBuilt());
        if (state is NewMessagesAdded || state is InitialMessagesDisplayed) {
          if (SchedulerBinding.instance != null &&
              _scrollController.hasClients) {
            SchedulerBinding.instance!.addPostFrameCallback((_) {
              _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeOut);
            });
          }
        }
        if (state is FailedToDisplayMoreMessages)
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
      },
      builder: (context, state) {
        if (state is ChatMessagesNetworkFailure)
          return NetworkErrorWidget(
            state.message,
            onReload: () {},
          );
        if (state is ChatMessagesServerFailure)
          return ServerErrorWidget(
            state.message,
            onReload: () {},
          );
        if (state is ChatMessagesLoading)
          return Center(
            child: CircularProgressIndicator(),
          );
        return CustomScrollView(
          center: _centerKey,
          controller: _scrollController,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return (state as MessagesDisplayChanged)
                    .topSliverMessages[index];
              },
                  childCount: (state as MessagesDisplayChanged)
                      .topSliverMessages
                      .length),
            ),
            SliverList(
              key: _centerKey,
              delegate: SliverChildBuilderDelegate((context, index) {
                return state.bottomSliverMessages[index];
              }, childCount: state.bottomSliverMessages.length),
            ),
          ],
        );
      },
    );
  }
}

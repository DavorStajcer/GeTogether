import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/core/widgets/network_error.dart';
import 'package:get_together_app/core/widgets/server_error.dart';
import 'package:get_together_app/features/chats_overview/presentation/bloc/chat_snippets_bloc/chat_snippet_bloc.dart';
import 'package:get_together_app/features/chats_overview/presentation/widgets/chat_snippet_widget.dart';

class UserChatSnippets extends StatefulWidget {
  final List<String> userChatIds;
  const UserChatSnippets(
    this.userChatIds, {
    Key? key,
  }) : super(key: key);

  @override
  _UserChatSnippetsState createState() => _UserChatSnippetsState();
}

class _UserChatSnippetsState extends State<UserChatSnippets> {
  late ChatSnippetsBloc chatSnippetsBloc;

  @override
  void initState() {
    super.initState();
    chatSnippetsBloc = BlocProvider.of<ChatSnippetsBloc>(context);
    chatSnippetsBloc.add(ChatsScreenInitialized(widget.userChatIds));
  }

  @override
  void dispose() {
    chatSnippetsBloc.add(ChatsScreenClosing());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatSnippetsBloc, ChatSnippetsState>(
      builder: (context, state) {
        if (state is ChatSnippetsLoading)
          return ListView.builder(
            itemCount: widget.userChatIds.length,
            itemBuilder: (context, index) => Center(
              child: CircularProgressIndicator(),
            ),
          );
        if (state is ChatSnippetNetworkFailure)
          return NetworkErrorWidget(state.message, onReload: () {});
        if (state is ChatSnippetServerFailure)
          return ServerErrorWidget(state.message, onReload: () {});
        return ListView.builder(
            itemCount: (state as ChatSnippetsLoaded).chatSnippets.length,
            itemBuilder: (context, index) =>
                ChatSnippetWidget(state.chatSnippets[index]));
      },
    );
  }
}

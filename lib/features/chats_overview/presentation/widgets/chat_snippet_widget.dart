import 'package:flutter/material.dart';
import 'package:get_together_app/features/chats_overview/domain/enitites/chat_snippet.dart';
import 'package:get_together_app/features/chats_overview/presentation/screens/chat_screen.dart';
import 'package:get_together_app/features/chats_overview/presentation/widgets/name_and_message.dart';

class ChatSnippetWidget extends StatelessWidget {
  final ChatSnippet chatSnippet;
  const ChatSnippetWidget(this.chatSnippet, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        ChatScreen.route,
        arguments: chatSnippet,
      ),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 100,
        padding: EdgeInsets.symmetric(horizontal: 25),
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Flexible(
              flex: 2,
              child: Container(
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(chatSnippet.adminImageUrl),
                  ),
                  color: Colors.grey,
                  border: Border.all(
                      width: 0.2, color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            Flexible(
              flex: 4,
              child: NameAndMessage(
                name: chatSnippet.eventName,
                messageSnippet: chatSnippet.lastMessageSnippet ?? " ",
                isUnread: chatSnippet.isUnread,
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    chatSnippet.sentBeforeString,
                    style: TextStyle(
                      fontWeight: chatSnippet.isUnread
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color:
                          chatSnippet.isUnread ? Colors.black : Colors.black26,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

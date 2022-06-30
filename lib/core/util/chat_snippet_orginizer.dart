import 'package:get_together_app/features/chats_overview/domain/enitites/chat_snippet.dart';

class ChatSnippetOrganizer {
  static List<ChatSnippet> orderChatSnippets(List<ChatSnippet> chatSnippets) {
    final unreadSnippets =
        chatSnippets.where((chatSnippet) => chatSnippet.isUnread).toList();
    final readSnippets =
        chatSnippets.where((chatSnippet) => !chatSnippet.isUnread).toList();
    final orderedUnreadSnippets = orderChatSnippetsByDate(unreadSnippets);
    final orderedReadSnippets = orderChatSnippetsByDate(readSnippets);
    return [...orderedReadSnippets, ...orderedUnreadSnippets].reversed.toList();
  }

  static List<ChatSnippet> orderChatSnippetsByDate(
      List<ChatSnippet> chatSnippets) {
    final orderedChatSnippets = [...chatSnippets];
    for (var i = 0; i < orderedChatSnippets.length; i++) {
      for (var j = 0; j < orderedChatSnippets.length - 1; j++) {
        if (isSecondChatSnippetOlder(
            orderedChatSnippets[j], orderedChatSnippets[j + 1])) {
          final firstSnippet = orderedChatSnippets[j];
          final secondSnippet = orderedChatSnippets[j + 1];
          orderedChatSnippets[j] = secondSnippet;
          orderedChatSnippets[j + 1] = firstSnippet;
        }
      }
    }
    return orderedChatSnippets.reversed.toList();
  }

  static List<ChatSnippet> orederChatSnippetsOnSnippetChange(
      List<ChatSnippet> snippets, ChatSnippet modifiedSnippet) {
    if (snippets.contains(modifiedSnippet)) return snippets;
    final modifiedList = [modifiedSnippet];
    final listWithoutModifiedSnippet = snippets
        .where((chatSnippet) => chatSnippet.eventId != modifiedSnippet.eventId);
    modifiedList.addAll([...listWithoutModifiedSnippet]);
    return modifiedList;
  }

  static bool isSecondChatSnippetOlder(ChatSnippet first, ChatSnippet second) {
    if (first.lastMessageDate != null && second.lastMessageDate != null)
      return second.lastMessageDate!.isBefore(first.lastMessageDate!);
    if (first.lastMessageDate == null && second.lastMessageDate != null) {
      if (first.chatCreation == null)
        return true;
      else
        return second.lastMessageDate!.isBefore(first.chatCreation!);
    }
    if (first.lastMessageDate != null && second.lastMessageDate == null) {
      if (second.chatCreation == null)
        return false;
      else
        return second.chatCreation!.isBefore(first.lastMessageDate!);
    } else {
      if (first.chatCreation != null && second.chatCreation != null)
        return second.chatCreation!.isBefore(first.chatCreation!);
      if (first.chatCreation == null && second.chatCreation != null)
        return true;
      if (first.chatCreation != null && second.chatCreation == null)
        return false;
      else
        return false;
    }
  }
}

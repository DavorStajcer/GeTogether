part of 'chat_messages_bloc.dart';

abstract class ChatMessagesState extends Equatable {
  const ChatMessagesState();

  @override
  List<Object?> get props => [];
}

class ChatMessagesLoading extends ChatMessagesState {}

class ChatMessagesFailure extends ChatMessagesState {
  final String message;
  ChatMessagesFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatMessagesNetworkFailure extends ChatMessagesFailure {
  ChatMessagesNetworkFailure(String message) : super(message);
}

class ChatMessagesServerFailure extends ChatMessagesFailure {
  ChatMessagesServerFailure(String message) : super(message);
}

class FailedToDisplayMoreMessages extends MessagesDisplayChanged {
  final String message = "Failed to load more messages..";
  FailedToDisplayMoreMessages(MessagesDisplayChanged currentState)
      : super(
          topSliverMessages: currentState.topSliverMessages,
          bottomSliverMessages: currentState.bottomSliverMessages,
          lastMessageDate: currentState.lastMessageDate,
        );
}

class InitialMessagesDisplayed extends MessagesDisplayChanged {
  InitialMessagesDisplayed(MessagesDisplayChanged currentState)
      : super(
          topSliverMessages: currentState.topSliverMessages,
          bottomSliverMessages: currentState.bottomSliverMessages,
          lastMessageDate: currentState.lastMessageDate,
        );
}

class MessagesDisplayChanged extends ChatMessagesState {
  final List<Widget> topSliverMessages;
  final List<Widget> bottomSliverMessages;
  final DateTime? lastMessageDate;
  MessagesDisplayChanged({
    required this.topSliverMessages,
    required this.bottomSliverMessages,
    required this.lastMessageDate,
  });

  @override
  List<Object?> get props => [
        topSliverMessages,
        bottomSliverMessages,
        lastMessageDate,
      ];
}

class InitialMessagesLoaded extends MessagesDisplayChanged {
  InitialMessagesLoaded({
    required List<Widget> topSliverMessages,
    required List<Widget> bottomSliverMessages,
    required DateTime? lastMessageDate,
  }) : super(
          topSliverMessages: topSliverMessages,
          bottomSliverMessages: bottomSliverMessages,
          lastMessageDate: lastMessageDate,
        );

  factory InitialMessagesLoaded.fromInitialMessages(
      List<Message> initMessages) {
    final List<Message> topSliverMessages = [];
    final List<Message> bottomSliverMessages = [];
    if (initMessages.isEmpty)
      return InitialMessagesLoaded(
        topSliverMessages: [],
        bottomSliverMessages: [],
        lastMessageDate: null,
      );
    for (int i = initMessages.length; i > 0; i--) {
      if (bottomSliverMessages.length < 10)
        bottomSliverMessages.add(initMessages[i - 1]);
      else
        topSliverMessages.add(initMessages[i - 1]);
    }
    DateTime? lastMessageDate;
    if (topSliverMessages.isNotEmpty)
      lastMessageDate = topSliverMessages.first.date;
    else if (bottomSliverMessages.isNotEmpty)
      lastMessageDate = bottomSliverMessages.first.date;

    DateTime? topSliverLastMessageDate;
    if (bottomSliverMessages.isNotEmpty)
      topSliverLastMessageDate = bottomSliverMessages.last.date;

    return InitialMessagesLoaded(
        topSliverMessages: _mapMessagesToWidgets(
          topSliverLastMessageDate,
          topSliverMessages,
          // topSliverMessages.isEmpty ? [] : topSliverMessages.reversed.toList(),
        ),
        bottomSliverMessages: _mapMessagesToWidgets(
            null,
            bottomSliverMessages.isEmpty
                ? []
                : bottomSliverMessages.reversed.toList()),
        lastMessageDate: lastMessageDate);
  }
}

class NewPageAdded extends MessagesDisplayChanged {
  NewPageAdded({
    required List<Widget> topSliverMessages,
    required List<Widget> bottomSliverMessages,
    required DateTime? lastMessageDate,
  }) : super(
          topSliverMessages: topSliverMessages,
          bottomSliverMessages: bottomSliverMessages,
          lastMessageDate: lastMessageDate,
        );

  factory NewPageAdded.addOnLoadedMessages(
    MessagesDisplayChanged currentState,
    List<Message> newPageMessages,
  ) {
    if (newPageMessages.isEmpty)
      return NewPageAdded(
          topSliverMessages: currentState.topSliverMessages,
          bottomSliverMessages: currentState.bottomSliverMessages,
          lastMessageDate: currentState.lastMessageDate);
    List<Widget> newTopSliverMessages = [];
    newTopSliverMessages.addAll(currentState.topSliverMessages);
    newTopSliverMessages.addAll(
        //0,
        _mapMessagesToWidgets(currentState.lastMessageDate, newPageMessages)
            .reversed);
    final lastMessageDate = newPageMessages.first.date;
    return NewPageAdded(
        topSliverMessages:
            newTopSliverMessages /* newTopSliverMessages.isEmpty
            ? []
            : newTopSliverMessages.reversed.toList() */
        ,
        bottomSliverMessages: currentState.bottomSliverMessages,
        lastMessageDate: lastMessageDate);
  }
}

class NewMessagesAdded extends MessagesDisplayChanged {
  NewMessagesAdded({
    required List<Widget> topSliverMessages,
    required List<Widget> bottomSliverMessages,
    required DateTime? lastMessageDate,
  }) : super(
          topSliverMessages: topSliverMessages,
          bottomSliverMessages: bottomSliverMessages,
          lastMessageDate: lastMessageDate,
        );
  factory NewMessagesAdded.addOnLoadedMessages(
      MessagesDisplayChanged currentState, List<Message> newPageMessages) {
    if (newPageMessages.isEmpty)
      return NewMessagesAdded(
          topSliverMessages: currentState.topSliverMessages,
          bottomSliverMessages: currentState.bottomSliverMessages,
          lastMessageDate: currentState.lastMessageDate);
    List<Widget> newBottomSliverMessages = [];
    newBottomSliverMessages.addAll(currentState.bottomSliverMessages);
    newBottomSliverMessages.addAll(
        _mapMessagesToWidgets(currentState.lastMessageDate, newPageMessages));
    return NewMessagesAdded(
        topSliverMessages: currentState.topSliverMessages,
        bottomSliverMessages: newBottomSliverMessages,
        lastMessageDate: currentState.lastMessageDate);
  }
}

List<Widget> _mapMessagesToWidgets(
    DateTime? lastLoadedDate, List<Message> newMessages) {
  final List<Widget> widgets = [];
  if (newMessages.isEmpty) return widgets;
  int? lastDay;
  int? lastMonth;
  int? lastYear;
  if (lastLoadedDate != null) {
    lastDay = lastLoadedDate.day;
    lastMonth = lastLoadedDate.month;
    lastYear = lastLoadedDate.year;
  }
  newMessages.forEach((message) {
    final messageDate = message.date;
    if (messageDate != null) {
      if (messageDate.day != lastDay ||
          messageDate.month != lastMonth ||
          messageDate.year != lastYear) {
        if (lastDay != null && lastMonth != null && lastYear != null)
          widgets.add(Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                DateFormater().getDotFormat(messageDate),
              )));
        lastDay = messageDate.day;
        lastMonth = messageDate.month;
        lastYear = messageDate.year;
      }
    }
    message.sender == Sender.currentUser
        ? widgets.add(MessageBubbleRight(message))
        : widgets.add(MessageBubbleLeft(message));
  });
  return widgets;
}

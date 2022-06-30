part of 'new_chats_bloc.dart';

abstract class NewChatsEvent extends Equatable {
  const NewChatsEvent();

  @override
  List<Object> get props => [];
}

class HomeScreenOpened extends NewChatsEvent {}

class NewChatsClosing extends NewChatsEvent {}

class NewChatsNumChanged extends NewChatsEvent {
  final num;
  NewChatsNumChanged(this.num);
}

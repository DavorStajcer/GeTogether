part of 'new_chats_bloc.dart';

abstract class NewChatsState extends Equatable {
  final int newChatsNum;
  const NewChatsState(this.newChatsNum);

  @override
  List<Object> get props => [newChatsNum];
}

class NewChatsStateInitial extends NewChatsState {
  NewChatsStateInitial() : super(0);
}

class NewChatsStateLoaded extends NewChatsState {
  NewChatsStateLoaded(int newChatsNum) : super(newChatsNum);
}

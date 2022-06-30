part of 'chats_overview_cubit.dart';

abstract class ChatsOverviewState extends Equatable {
  const ChatsOverviewState();

  @override
  List<Object> get props => [];
}

class ChatsOverviewLoading extends ChatsOverviewState {}

class ChatsOverviewFailure extends ChatsOverviewState {
  final String message;
  ChatsOverviewFailure(this.message);

  @override
  List<Object> get props => [message];
}

class ChatsOverviewNetworkFailure extends ChatsOverviewFailure {
  ChatsOverviewNetworkFailure(String message) : super(message);
}

class ChatsOverviewServerFailure extends ChatsOverviewFailure {
  ChatsOverviewServerFailure(String message) : super(message);
}

class ChatsOverviewLoaded extends ChatsOverviewState {
  final List<String> userChatIds;
  ChatsOverviewLoaded(this.userChatIds);

  @override
  List<Object> get props => [userChatIds];
}

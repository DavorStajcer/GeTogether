part of 'single_event_screen_cubit.dart';

abstract class SingleEventScreenState extends Equatable {
  const SingleEventScreenState();

  @override
  List<Object> get props => [];
}

class SingleEventScreenLoading extends SingleEventScreenState {}

class SingleEventScreenFailure extends SingleEventScreenState {
  final String message;
  SingleEventScreenFailure(this.message);

  @override
  List<Object> get props => [message];
}

class SingleEventScreenLoaded extends SingleEventScreenState {
  final isCurrentUserEventAdmin;
  SingleEventScreenLoaded(this.isCurrentUserEventAdmin);

  @override
  List<Object> get props => [isCurrentUserEventAdmin];
}

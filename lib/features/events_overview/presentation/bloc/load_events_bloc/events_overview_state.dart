part of 'events_overview_bloc.dart';

abstract class EventsOverviewState extends Equatable {
  const EventsOverviewState();

  @override
  List<Object> get props => [];
}

class EventsOverviewLoading extends EventsOverviewState {}

abstract class EventsOverviewFailure extends EventsOverviewState {
  final message;
  EventsOverviewFailure(this.message);

  @override
  List<Object> get props => [message];
}

class EventsOverviewNetworkFailure extends EventsOverviewFailure {
  EventsOverviewNetworkFailure(message) : super(message);
}

class EventsOverviewServerFailure extends EventsOverviewFailure {
  EventsOverviewServerFailure(message) : super(message);
}

class EventsOverviewLoaded extends EventsOverviewState {
  final List<Event> events;
/*   final currentlySelectedEvent; */
  EventsOverviewLoaded({
/*     this.currentlySelectedEvent =
        -1, // -1 means that no event is selected (when events are first loaded to the screen) */
    required this.events,
  });

  @override
  List<Object> get props => [
        events,
        /*       currentlySelectedEvent, */
      ];
}

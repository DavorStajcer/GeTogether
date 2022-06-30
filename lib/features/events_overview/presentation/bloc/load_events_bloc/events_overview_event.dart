part of 'events_overview_bloc.dart';

abstract class EventsOverviewEvent extends Equatable {
  const EventsOverviewEvent();

  @override
  List<Object> get props => [];
}

class EventsScreenInitialized extends EventsOverviewEvent {}

class EventChosen extends EventsOverviewEvent {
  final String eventId;
  EventChosen(this.eventId);
}

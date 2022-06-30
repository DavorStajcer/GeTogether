import 'package:equatable/equatable.dart';
import 'package:get_together_app/features/make_event/domain/entities/create_event_data.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_card_order_cubit/event_card_order_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class EventState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventStateLoading extends EventState {}

abstract class EventStateFailure extends EventState {
  final String message;
  EventStateFailure(this.message);
}

class EventStateNetworkFailure extends EventStateFailure {
  EventStateNetworkFailure(String message) : super(message);
}

class EventStateServerFailure extends EventStateFailure {
  EventStateServerFailure(String message) : super(message);
}

class EventStateCreated extends EventState {}

class EventStateUnfinished extends EventState {
  final CreateEventData createEventData;

  EventStateUnfinished(
      {CreateEventData? createEventData, LatLng? currentUserPosition})
      : createEventData = createEventData ??
            CreateEventData(
              type: EventType.games,
              location: LatLng(0, 0),
              currentUserPosition: LatLng(0, 0),
              eventName: "",
              description: "This is some event.",
              dateString: null,
              timeString: null,
            );

  EventStateUnfinished copyWith({
    EventType? type,
    LatLng? location,
    String? eventName,
    String? description,
    String? dateString,
    String? timeString,
    LatLng? currentUserPosition,
  }) =>
      EventStateUnfinished(
        createEventData: CreateEventData(
          type: type ?? this.createEventData.type,
          location: location ?? this.createEventData.location,
          eventName: eventName ?? this.createEventData.eventName,
          description: description ?? this.createEventData.description,
          dateString: dateString ?? this.createEventData.dateString,
          timeString: timeString ?? this.createEventData.timeString,
          currentUserPosition:
              currentUserPosition ?? this.createEventData.currentUserPosition,
        ),
      );

  @override
  List<Object?> get props => [createEventData];
}

class EventStateLocationOutOfRange extends EventStateUnfinished {
  EventStateLocationOutOfRange({
    required CreateEventData createEventData,
  }) : super(
          createEventData: createEventData,
        );

  EventStateLocationOutOfRange copyWith({
    EventType? type,
    LatLng? location,
    String? eventName,
    String? description,
    String? dateString,
    String? timeString,
    LatLng? currentUserPosition,
  }) =>
      EventStateLocationOutOfRange(
        createEventData: CreateEventData(
          type: type ?? this.createEventData.type,
          location: location ?? this.createEventData.location,
          eventName: eventName ?? this.createEventData.eventName,
          description: description ?? this.createEventData.description,
          dateString: dateString ?? this.createEventData.dateString,
          timeString: timeString ?? this.createEventData.timeString,
          currentUserPosition:
              currentUserPosition ?? this.createEventData.currentUserPosition,
        ),
      );

  factory EventStateLocationOutOfRange.fromUnfinishedState(
          EventStateUnfinished state) =>
      EventStateLocationOutOfRange(
        createEventData: state.createEventData.copyWith(),
      );

  @override
  List<Object?> get props => [createEventData];
}

class EventStateFinished extends EventStateUnfinished {
  EventStateFinished(CreateEventData createEventData)
      : super(createEventData: createEventData);
}

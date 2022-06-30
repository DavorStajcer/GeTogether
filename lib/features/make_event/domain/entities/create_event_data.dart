import 'package:equatable/equatable.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_card_order_cubit/event_card_order_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateEventData extends Equatable {
  final EventType type;
  final LatLng location;
  final String eventName;
  final String description;
  final String? dateString;
  final String? timeString;
  final LatLng currentUserPosition;

  CreateEventData({
    required this.type,
    required this.location,
    required this.eventName,
    required this.description,
    required this.dateString,
    required this.currentUserPosition,
    required this.timeString,
  });

  CreateEventData copyWith({
    EventType? type,
    LatLng? location,
    String? eventName,
    String? description,
    String? dateString,
    String? timeString,
    LatLng? currentUserPosition,
  }) =>
      CreateEventData(
        type: type ?? this.type,
        location: location ?? this.location,
        eventName: eventName ?? this.eventName,
        description: description ?? this.description,
        dateString: dateString ?? this.dateString,
        timeString: timeString ?? this.timeString,
        currentUserPosition: currentUserPosition ?? this.currentUserPosition,
      );

  @override
  List<Object?> get props => [
        type,
        location.latitude,
        location.longitude,
        currentUserPosition.latitude,
        currentUserPosition.longitude,
        description,
        eventName,
        dateString,
        timeString,
      ];
}

import 'package:equatable/equatable.dart';
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';

enum EventChange { join, leave }

class EventJoinData extends Equatable {
  //final String eventId;
  //final String eventCity;
  final Event event;
  final EventChange eventChange;
  EventJoinData({
    required this.event,
    // required this.eventCity,
    required this.eventChange,
  });

  @override
  List<Object?> get props => [
        // eventId,
        //  eventCity,
        event,
        eventChange,
      ];
}

import 'package:equatable/equatable.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_card_order_cubit/event_card_order_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Event extends Equatable {
  final String eventId;
  final EventType eventType;
  final String dateString;
  final String timeString;
  final LatLng location;
  final String adminId;
  final String adminUsername;
  final String adminImageUrl;
  final int adminRating;
  final int numberOfPeople;
  final String eventName;
  final String description;
  final Map<String, dynamic> peopleImageUrls;

  Event({
    required this.eventId,
    required this.eventType,
    required this.dateString,
    required this.timeString,
    required this.location,
    required this.adminId,
    required this.adminUsername,
    required this.adminImageUrl,
    required this.adminRating,
    required this.numberOfPeople,
    required this.eventName,
    required this.description,
    required this.peopleImageUrls,
  });

  @override
  List<Object?> get props => [
        eventId,
        eventType,
        dateString,
        timeString,
        location,
        adminId,
        adminUsername,
        adminImageUrl,
        adminRating,
        numberOfPeople,
        description,
        peopleImageUrls,
      ];
}

import 'package:get_together_app/features/events_overview/domain/entities/event.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_card_order_cubit/event_card_order_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventModel extends Event {
  EventModel({
    required String eventId,
    required EventType eventType,
    required String dateString,
    required String timeString,
    required LatLng location,
    required String adminId,
    required String adminUsername,
    required String adminImageUrl,
    required int adminRating,
    required int numberOfPeople,
    required String eventName,
    required String description,
    required Map<String, dynamic> peopleImageUrls,
  }) : super(
          eventId: eventId,
          eventType: eventType,
          dateString: dateString,
          timeString: timeString,
          location: location,
          adminId: adminId,
          adminUsername: adminUsername,
          adminImageUrl: adminImageUrl,
          adminRating: adminRating,
          numberOfPeople: numberOfPeople,
          eventName: eventName,
          description: description,
          peopleImageUrls: peopleImageUrls,
        );

  factory EventModel.fromJsonMap(String eventId, Map<String, dynamic> json) =>
      EventModel(
        eventId: eventId,
        eventType: _mapEventIndexToType(json["eventType"]),
        dateString: json["dateString"],
        timeString: json["timeString"],
        location: LatLng(
          json["location"]["latitude"],
          json["location"]["longitude"],
        ),
        adminId: json["adminId"],
        adminUsername: json["adminUsername"],
        adminImageUrl: json["adminImageUrl"],
        adminRating: json["adminRating"] is double
            ? (json["adminRating"] as double).toInt()
            : json["adminRating"],
        numberOfPeople: json["numberOfPeople"] is double
            ? (json["numberOfPeople"] as double).toInt()
            : json["numberOfPeople"],
        eventName: json["eventName"],
        description: json["description"],
        peopleImageUrls: json["peopleImageUrls"],
      );

  Map<String, dynamic> toJsonMap() => {
        // "eventId": eventId,
        "eventType": eventType.index,
        "dateString": dateString,
        "timeString": timeString,
        "location": {
          "latitude": location.latitude,
          "longitude": location.longitude
        },
        "adminId": adminId,
        "adminUsername": adminUsername,
        "adminImageUrl": adminImageUrl,
        "adminRating": adminRating,
        "numberOfPeople": numberOfPeople,
        "description": description,
        "peopleImageUrls": peopleImageUrls,
        "eventName": eventName,
      };
}

EventType _mapEventIndexToType(int index) {
  switch (index) {
    case 0:
      return EventType.games;
    case 1:
      return EventType.coffe;
    case 2:
      return EventType.food;
    default:
      return EventType.games;
  }
}

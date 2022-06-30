//@dart=2.6

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/features/events_overview/data/models/event_model.dart';
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';

import 'package:get_together_app/features/make_event/presentation/blocs/event_card_order_cubit/event_card_order_cubit.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../fixtures/fixture_string_converter.dart';

void main() {
  EventModel event;

  setUp(() {
    event = EventModel(
        eventId: "userId",
        eventType: EventType.games,
        dateString: "07.12.1998.",
        timeString: "21:10",
        location: LatLng(0, 0),
        adminId: "adminId",
        adminUsername: "adminUsername",
        adminImageUrl: "adminImageUrl",
        adminRating: 0,
        numberOfPeople: 0,
        description: "description",
        peopleImageUrls: {
          "userId1": "url1",
          "userId2": "url2",
          "userId3": "url3",
        });
  });

  test("should be an instance of Event", () {
    expect(event, isInstanceOf<Event>());
  });

  test("should convert itself to a json Map", () {
    final map = event.toJsonMap();
    final expected = json.decode(getStringJsonFromFixture(
        "event_fixture.json")); //when you do json.encode(map) and when you compare it with the getStringJsonFromFixture() it is not completly eaqual bcs of some string stuff, but it looks good
    expect(map, expected);
  });

  test("should make new instance from json map", () {
    final jsonMap = json.decode(getStringJsonFromFixture("event_fixture.json"));
    final instance = EventModel.fromJsonMap("userId", jsonMap);
    expect(instance, event);
  });
}

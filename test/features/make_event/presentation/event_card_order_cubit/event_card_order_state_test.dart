//@dart=2.6

import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_card_order_cubit/event_card_order_cubit.dart';

void main() {
  EventCardOrderInitial eventCardOrderInitial;

  setUp(() {
    eventCardOrderInitial = EventCardOrderInitial();
  });

  test("Card order of initial state should be games, coffe, food", () {
    expect(eventCardOrderInitial.eventTypeOrder, [
      EventType.games,
      EventType.coffe,
      EventType.food,
    ]);
  });
  test("When an order is passed to a custom order that order should remain",
      () {
    EventCardOrderCustom eventCardOrderCustom = EventCardOrderCustom([
      EventType.coffe,
      EventType.games,
      EventType.food,
    ]);
    expect(eventCardOrderCustom.eventTypeOrder, [
      EventType.coffe,
      EventType.games,
      EventType.food,
    ]);
  });
}

//@dart=2.6

import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_card_order_cubit/event_card_order_cubit.dart';

import 'package:get_together_app/features/make_event/presentation/util/order_modifier.dart';

void main() {
  OrderModifierImpl orderModifierImpl;

  setUp(() {
    orderModifierImpl = OrderModifierImpl();
  });

  test(
      "should move the picked card to top,it should be first element in the list",
      () {
    final newOrder = orderModifierImpl.moveToTop(
      [
        EventType.games,
        EventType.coffe,
        EventType.food,
      ],
      EventType.coffe,
    );
    expect(
      newOrder,
      [
        EventType.coffe,
        EventType.games,
        EventType.food,
      ],
    );
  });
  test("should be in the right order -> from lower to higher", () {
    var newOrder = orderModifierImpl.moveToTop(
      [
        EventType.games,
        EventType.coffe,
        EventType.food,
      ],
      EventType.coffe,
    );
    newOrder = orderModifierImpl.moveToTop(
      newOrder,
      EventType.food,
    );
    expect(
      newOrder,
      [
        EventType.food,
        EventType.games,
        EventType.coffe,
      ],
    );
  });
}

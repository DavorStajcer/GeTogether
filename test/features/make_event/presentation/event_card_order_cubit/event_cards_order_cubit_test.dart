//@dart=2.6

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_card_order_cubit/event_card_order_cubit.dart';

import 'package:get_together_app/features/make_event/presentation/util/order_modifier.dart';
import 'package:mockito/mockito.dart';

class OrderModifierMock extends Mock implements OrderModifier {}

void main() {
  EventCardOrderCubit eventCardOrderCubit;
  OrderModifierImpl orderModifierImpl;

  setUp(() {
    orderModifierImpl = OrderModifierImpl();
    eventCardOrderCubit = EventCardOrderCubit(orderModifierImpl);
  });

  test("initial state should be EventCardOrderInital", () {
    expect(eventCardOrderCubit.state, EventCardOrderInitial());
  });

  blocTest("should return state with X on top",
      build: () {
        return eventCardOrderCubit;
      },
      act: (cubit) {
        (cubit as EventCardOrderCubit).putToTop(EventType.coffe);
        (cubit as EventCardOrderCubit).putToTop(EventType.games);
        (cubit as EventCardOrderCubit).putToTop(EventType.food);
      },
      expect: () => [
            EventCardOrderCustom(
              [
                EventType.coffe,
                EventType.games,
                EventType.food,
              ],
            ),
            EventCardOrderCustom(
              [
                EventType.games,
                EventType.coffe,
                EventType.food,
              ],
            ),
            EventCardOrderCustom(
              [
                EventType.food,
                EventType.games,
                EventType.coffe,
              ],
            ),
          ]);
}

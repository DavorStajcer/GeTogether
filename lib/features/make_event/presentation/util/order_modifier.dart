import 'package:get_together_app/features/make_event/presentation/blocs/event_card_order_cubit/event_card_order_cubit.dart';

abstract class OrderModifier {
  List<EventType> moveToTop(List<EventType> order, EventType eventType);
}

class OrderModifierImpl implements OrderModifier {
  @override
  List<EventType> moveToTop(List<EventType> order, EventType eventType) {
    //Get inital type order (sorted order)
    List<EventType> sortedList = EventCardOrderInitial().eventTypeOrder;
    final List<EventType> newList = [];
    //Put the event type that is picked in first place of the list -> first place of the list represents the top of the stack
    newList.add(eventType);
    //put other elements in the list from the sorted array -> this way other elements are stacked on top of each other from left to right
    sortedList.forEach((element) {
      if (element != eventType) newList.add(element);
    });
    return newList;
  }
}

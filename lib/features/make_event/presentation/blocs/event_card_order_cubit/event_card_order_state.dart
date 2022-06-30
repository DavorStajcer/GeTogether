part of 'event_card_order_cubit.dart';

enum EventType { games, coffe, food }

abstract class EventCardOrderState extends Equatable {
  final List<EventType> eventTypeOrder;
  const EventCardOrderState({required this.eventTypeOrder});

  @override
  List<Object> get props => [eventTypeOrder];
}

class EventCardOrderInitial extends EventCardOrderState {
  EventCardOrderInitial()
      : super(
          eventTypeOrder: [
            EventType.games,
            EventType.coffe,
            EventType.food,
          ],
        );
}

class EventCardOrderCustom extends EventCardOrderState {
  const EventCardOrderCustom(List<EventType> newOrder)
      : super(eventTypeOrder: newOrder);
}

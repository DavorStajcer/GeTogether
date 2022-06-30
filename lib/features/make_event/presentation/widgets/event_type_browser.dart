import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_card_order_cubit/event_card_order_cubit.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_cubit/event_cubit.dart';
import 'package:get_together_app/features/make_event/presentation/widgets/event_type_card.dart';

class EvenTypeBrowser extends StatelessWidget {
  const EvenTypeBrowser({Key? key}) : super(key: key);

  final Map<EventType, Widget> _eventTypeCard = const {
    EventType.coffe: EventTypeCard(
      eventType: EventType.coffe,
    ),
    EventType.food: EventTypeCard(
      eventType: EventType.food,
    ),
    EventType.games: EventTypeCard(
      eventType: EventType.games,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCardOrderCubit, EventCardOrderState>(
      builder: (context, state) {
        BlocProvider.of<EventCubit>(context)
            .eventTypeChanged(state.eventTypeOrder[0]);
        return Stack(
          alignment: Alignment.centerLeft,
          children: state.eventTypeOrder
              .map((eventType) => _eventTypeCard[eventType]!)
              .toList()
              .reversed
              .toList(),
        );
      },
    );
  }
}

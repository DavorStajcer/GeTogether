import 'package:flutter/material.dart';
import 'package:get_together_app/core/widgets/event_card/admin_pic_and_icon.dart';
import 'package:get_together_app/core/widgets/event_card/username_and_rating.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_card_order_cubit/event_card_order_cubit.dart';

class EventAdmin extends StatelessWidget {
  final String imageUrl;
  final EventType eventType;
  final String username;
  final String eventName;
  final int numberOfPeople;
  const EventAdmin({
    Key? key,
    required this.imageUrl,
    required this.eventType,
    required this.eventName,
    required this.username,
    required this.numberOfPeople,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AdminPicAndIcon(
            imageUrl: imageUrl,
            eventType: eventType,
          ),
        ),
        Expanded(
          child: UsernameAndRating(
              rating: 5,
              adminUsername: username,
              eventName: eventName,
              numberOfPeople: numberOfPeople),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get_together_app/core/widgets/event_card/event_admin.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_card_order_cubit/event_card_order_cubit.dart';

class AdminDetails extends StatelessWidget {
  final EventType eventType;
  final String adminImageUrl;
  final String eventName;
  final int numberOfPeople;
  final String adminUsername;
  const AdminDetails({
    Key? key,
    required this.eventType,
    required this.adminImageUrl,
    required this.eventName,
    required this.numberOfPeople,
    required this.adminUsername,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Text(
              "Admin",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(),
        ),
        Flexible(
          flex: 5,
          child: Center(
            child: EventAdmin(
              eventType: eventType,
              imageUrl: adminImageUrl,
              // numberOfPeople: numberOfPeople,
              eventName: eventName,
              username: adminUsername,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(),
        ),
      ],
    );
  }
}

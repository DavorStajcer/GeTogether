import 'package:flutter/material.dart';
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';
import 'package:get_together_app/features/single_event_overview/presentation/widgets/admin_details.dart';
import 'package:get_together_app/features/single_event_overview/presentation/widgets/description.dart';
import 'package:get_together_app/features/single_event_overview/presentation/widgets/join_button.dart';
import 'package:get_together_app/features/single_event_overview/presentation/widgets/people_comming..dart';

class EventDetails extends StatelessWidget {
  final Event event;
  final bool isCurrentUserEventAdmin;
  const EventDetails(
      {Key? key, required this.event, required this.isCurrentUserEventAdmin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 1,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Row(
              children: [
                Flexible(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Text(
                      "Date/Time",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      "${event.dateString}. / ${event.timeString}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: AdminDetails(
              eventType: event.eventType,
              adminImageUrl: event.adminImageUrl,
              adminUsername: event.adminUsername,
              eventName: event.eventName,
              numberOfPeople: event.numberOfPeople,
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Description(event.description),
          ),
        ),
        Flexible(
          flex: 3,
          child: PoepleComming(event.peopleImageUrls),
        ),
        Flexible(
          flex: 1,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: isCurrentUserEventAdmin
                ? SizedBox()
                : JoinButton(
                    event: event,
                  ),
          ),
        ),
      ],
    );
  }
}

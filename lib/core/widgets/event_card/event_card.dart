import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/core/widgets/event_card/event_admin.dart';
import 'package:get_together_app/core/widgets/event_card/find_out_more_button.dart';
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';
import 'package:get_together_app/features/events_overview/presentation/bloc/event_pick_cubit/event_pick_cubit_cubit.dart';

class EventCard extends StatefulWidget {
  final Event event;
  final double elevation;
  final Color color;
  final double width;
  const EventCard({
    Key? key,
    required this.event,
    required this.elevation,
    required this.color,
    required this.width,
  }) : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => BlocProvider.of<EventPickCubit>(context)
          .eventPicked(widget.event.eventId, widget.event.location),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: widget.width,
        child: Card(
          elevation: widget.elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          color: widget.color,
          child: Container(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Expanded(
                  child: EventAdmin(
                    eventType: widget.event.eventType,
                    imageUrl: widget.event.adminImageUrl,
                    username: widget.event.adminUsername,
                    eventName: widget.event.eventName,
                    numberOfPeople: widget.event.numberOfPeople,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: AutoSizeText(
                      widget.event.description,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13),
                      softWrap: true,
                      maxLines: 5,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Date:  "),
                            Text(widget.event.dateString),
                          ],
                        ),
                      ),
                      Container(
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        width: double.infinity,
                        child: FittedBox(
                          child: FindOutMoreButton(widget.event),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

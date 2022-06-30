import "package:flutter/material.dart";
import 'package:get_together_app/features/events_overview/domain/entities/event.dart';
import 'package:get_together_app/features/single_event_overview/presentation/screens/single_event_screen.dart';

class FindOutMoreButton extends StatelessWidget {
  final Event event;
  const FindOutMoreButton(this.event, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.pressed))
              return Theme.of(context).primaryColor.withOpacity(0.7);
            return Theme.of(context).primaryColor;
          },
        ),
      ),
      onPressed: //onButtonPressed
          () => Navigator.of(context)
              .pushNamed(SingleEventScreen.route, arguments: event),
      child: Text(
        "Find out more",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

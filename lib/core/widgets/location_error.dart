import 'package:flutter/material.dart';
import 'package:get_together_app/features/make_event/presentation/widgets/event_button.dart';

class LocationErrorWidget extends StatelessWidget {
  final String message;
  final Function() onReload;
  const LocationErrorWidget(this.message, {Key? key, required this.onReload})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Flexible(
            flex: 5,
            child: Column(
              children: [
                Expanded(
                  child: Icon(
                    Icons.location_disabled,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: EventButton(
                text: "Refresh page",
                buttonColor: Theme.of(context).primaryColor,
                textColor: Colors.white,
                navigate: onReload),
          ),
        ],
      ),
    );
  }
}

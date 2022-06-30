import 'package:flutter/material.dart';
import 'package:get_together_app/features/make_event/presentation/widgets/event_button.dart';

class NetworkErrorWidget extends StatelessWidget {
  final String message;
  final Function() onReload;
  const NetworkErrorWidget(
    this.message, {
    required this.onReload,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Flexible(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  message,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: EventButton(text: "Refresh page", navigate: onReload),
          ),
          Flexible(
            flex: 1,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}

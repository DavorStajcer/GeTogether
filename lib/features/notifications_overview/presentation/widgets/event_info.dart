import 'package:flutter/material.dart';
import 'package:get_together_app/features/notifications_overview/domain/entities/notification.dart'
    as not;

class EventInfoWidget extends StatelessWidget {
  final not.EventInfoNotification notification;
  const EventInfoWidget(this.notification, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        //eight: 100,
        margin: EdgeInsets.symmetric(horizontal: 8),
        padding: EdgeInsets.symmetric(horizontal: 8),
        width: double.infinity,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(8),
              child: Text(
                notification.content,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(),
          ],
        ));
  }
}

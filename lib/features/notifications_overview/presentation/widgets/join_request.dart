import 'package:flutter/material.dart';
import 'package:get_together_app/features/notifications_overview/data/models/notification_model.dart';
import 'package:get_together_app/features/notifications_overview/presentation/widgets/notification_buttons.dart';

enum NotificationResolved { pending, accepted, rejected }

class JoinRequestWidget extends StatelessWidget {
  final JoinEventNotificationModel notification;
  const JoinRequestWidget(this.notification, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            //flex: 10,
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(notification.senderImageUrl),
                      ),
                      color: Colors.grey,
                      border: Border.all(
                          width: 0.2, color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      notification.content,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: notification.resolvedStatus ==
                            NotificationResolved.pending
                        ? NotificationButtons(notification)
                        : notification.resolvedStatus ==
                                NotificationResolved.accepted
                            ? Icon(Icons.done_rounded)
                            : Icon(Icons.do_not_disturb_on),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}

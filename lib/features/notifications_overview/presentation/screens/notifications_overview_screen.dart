import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/core/widgets/get_together_title.dart';
import 'package:get_together_app/core/widgets/network_error.dart';
import 'package:get_together_app/core/widgets/server_error.dart';
import 'package:get_together_app/features/home/presentation/bloc/new_notifications_bloc/new_notifications_bloc.dart';
import 'package:get_together_app/features/notifications_overview/data/models/notification_model.dart';
import 'package:get_together_app/features/notifications_overview/domain/entities/notification.dart';
import 'package:get_together_app/features/notifications_overview/presentation/bloc/notifications_bloc/notifications_bloc.dart';
import 'package:get_together_app/features/notifications_overview/presentation/bloc/notifications_bloc/notifications_bloc_event.dart';
import 'package:get_together_app/features/notifications_overview/presentation/bloc/notifications_bloc/notifications_bloc_state.dart';
import 'package:get_together_app/features/notifications_overview/presentation/widgets/event_info.dart';
import 'package:get_together_app/features/notifications_overview/presentation/widgets/join_request.dart';
import 'package:get_together_app/features/notifications_overview/presentation/widgets/leave_event_info.dart';
import 'package:get_together_app/features/notifications_overview/presentation/widgets/no_notifications.dart';

class NotificationsOverviewScreen extends StatefulWidget {
  const NotificationsOverviewScreen({Key? key}) : super(key: key);

  @override
  _NotificationsOverviewScreenState createState() =>
      _NotificationsOverviewScreenState();
}

class _NotificationsOverviewScreenState
    extends State<NotificationsOverviewScreen> {
  late NotificationsBloc notificationsBloc;
  @override
  void initState() {
    super.initState();
    notificationsBloc = BlocProvider.of<NotificationsBloc>(context);
    notificationsBloc.add(NotificationsScreenInitialized());
  }

  @override
  void dispose() {
    notificationsBloc.add(NotificationScreenLeft());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SafeArea(
        child: Column(
      children: [
        Container(
          height: screenSize.height * 0.15,
          alignment: Alignment.topCenter,
          child: GetTogetherTitle(
            textColor: Theme.of(context).primaryColor,
          ),
        ),
        Expanded(child: BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            if (state is NotificationsServerFailure)
              return ServerErrorWidget(
                state.message,
                onReload: () {},
              );
            if (state is NotificationsNetworkFailure)
              return NetworkErrorWidget(
                state.message,
                onReload: () {},
              );
            else
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: (state as NotificationsLoaded).notifications.length == 0
                    ? NoNotifications()
                    : ListView.builder(
                        itemCount: state.notifications.length,
                        itemBuilder: (context, index) {
                          final notification = state.notifications[index];
                          if (notification is JoinEventNotification)
                            return JoinRequestWidget(
                                notification as JoinEventNotificationModel);
                          else if (notification is LeaveEventInfoNotification)
                            return LeaveEventInfoWidget(notification
                                as LeaveEventInfoNotificationModel);
                          else
                            return EventInfoWidget(notification);
                        },
                      ),
              );
          },
        )),
      ],
    ));
  }
}

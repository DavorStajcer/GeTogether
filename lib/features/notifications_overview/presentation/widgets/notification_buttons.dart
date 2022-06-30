import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/features/make_event/presentation/widgets/event_button.dart';
import 'package:get_together_app/features/notifications_overview/data/models/notification_model.dart';
import 'package:get_together_app/features/notifications_overview/presentation/bloc/event_answer_cubit/event_answer_cubit.dart';

class NotificationButtons extends StatelessWidget {
  final JoinEventNotificationModel notification;
  const NotificationButtons(this.notification, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventAnswerCubit, EventAnswerState>(
      listener: (context, state) {
        if (state is EventAnswerFailure)
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to register your answer.")));
      },
      builder: (context, state) {
        if (state is EventAnswerLoading)
          return Center(
            child: CircularProgressIndicator(),
          );
        if (state is EventAnswerAccepted) return Icon(Icons.done_rounded);
        if (state is EventAnswerRejected) return Icon(Icons.do_not_disturb_on);

        return Column(
          children: [
            Expanded(
              child: EventButton(
                  text: "Accept",
                  buttonColor: Theme.of(context).primaryColor.withOpacity(0.6),
                  textColor: Colors.white,
                  navigate: () => BlocProvider.of<EventAnswerCubit>(context)
                      .acceptJoinRequest(notification)),
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: EventButton(
                  text: "Decline",
                  buttonColor: Colors.white,
                  textColor: Theme.of(context).primaryColor.withOpacity(0.6),
                  navigate: () => BlocProvider.of<EventAnswerCubit>(context)
                      .declineRequest(notification)),
            ),
          ],
        );
      },
    );
  }
}

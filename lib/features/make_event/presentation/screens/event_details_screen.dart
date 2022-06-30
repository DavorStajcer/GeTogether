import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_cubit/event_cubit.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_cubit/event_state.dart';
import 'package:get_together_app/features/make_event/presentation/widgets/date_time_picker_button.dart';
import 'package:get_together_app/features/make_event/presentation/widgets/event_button_with_back_icon.dart';
import 'package:get_together_app/features/make_event/presentation/widgets/event_description.dart';

class EventDetailsScreen extends StatelessWidget {
  final Function(BuildContext) createEvent;
  final Function() goBack;
  final Function() onError;
  EventDetailsScreen({
    Key? key,
    required this.createEvent,
    required this.goBack,
    required this.onError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.055),
      child: Column(
        children: [
          Flexible(
            flex: 10,
            child: EventNameAndDescription(
              onError: this.onError,
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              height: double.infinity,
              child: Row(
                children: [
                  Flexible(
                    flex: 4,
                    child: DateTimePickerButton(
                      pickerType: Picker.date,
                    ),
                  ),
                  Flexible(flex: 1, child: Container()),
                  Flexible(
                    flex: 3,
                    child: DateTimePickerButton(
                      pickerType: Picker.time,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: BlocBuilder<EventCubit, EventState>(
              builder: (context, state) {
                return EventButtonWithBackIcon(
                  text: "Make event",
                  goBack: goBack,
                  goFowards: () {
                    if (state is EventStateFinished) createEvent(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

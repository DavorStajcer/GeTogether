import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/core/util/date_formater.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_cubit/event_cubit.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_cubit/event_state.dart';

enum Picker { date, time }

class DateTimePickerButton extends StatelessWidget {
  final Picker pickerType;
  const DateTimePickerButton({Key? key, required this.pickerType})
      : super(key: key);

  Future<DateTime?> _selectEventDate(
      BuildContext context, DateTime? currentlySelectedDate) async {
    log("smthDebug: selecting event date, currentlySelected $currentlySelectedDate");
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentlySelectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 430)),
      helpText: "Change event date",
      initialEntryMode: DatePickerEntryMode.input,
    );
    if (pickedDate != null && pickedDate != currentlySelectedDate)
      BlocProvider.of<EventCubit>(context).eventDateChanged(pickedDate);
    return pickedDate;
  }

  Future<TimeOfDay?> _selectEventTime(
      BuildContext context, TimeOfDay? currentlySelectedTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: currentlySelectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != currentlySelectedTime)
      BlocProvider.of<EventCubit>(context)
          .eventTimeChanged(pickedTime.format(context));
    return pickedTime;
  }

  @override
  Widget build(BuildContext context) {
    // final DateFormater dateFormater = DateFormater();
    TimeOfDay? currentlySelectedTime;
    DateTime? currentlySelectedDate;
    return Column(
      children: [
        Flexible(
          flex: 1,
          child: Container(),
        ),
        Flexible(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0),
                            Theme.of(context).primaryColor.withOpacity(0.05),
                            Theme.of(context).primaryColor.withOpacity(0.1),
                            Theme.of(context).primaryColor.withOpacity(0.3),
                          ],
                          stops: [0.2, 0.4, 0.65, 1],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          tileMode: TileMode.repeated,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: BlocBuilder<EventCubit, EventState>(
                          builder: (context, state) {
                        if (state is EventStateLoading ||
                            state is EventStateCreated)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        if (state is EventStateFailure)
                          return FittedBox(child: Text("???"));

                        return FittedBox(
                          fit: BoxFit.fitWidth,
                          child: AutoSizeText(
                            pickerType == Picker.time
                                ? (state as EventStateUnfinished)
                                        .createEventData
                                        .timeString ??
                                    "Pick time ->"
                                : (state as EventStateUnfinished)
                                        .createEventData
                                        .dateString ??
                                    "Pick date ->",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.6),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      child: IconButton(
                        icon: Icon(
                          Icons.replay_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () async {
                          pickerType == Picker.time
                              ? currentlySelectedTime = await _selectEventTime(
                                  context, currentlySelectedTime)
                              : currentlySelectedDate = await _selectEventDate(
                                  context, currentlySelectedDate);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(),
        ),
      ],
    );
  }
}

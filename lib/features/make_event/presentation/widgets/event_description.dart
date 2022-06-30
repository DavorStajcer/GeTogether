import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/core/widgets/network_error.dart';
import 'package:get_together_app/core/widgets/server_error.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_cubit/event_cubit.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_cubit/event_state.dart';

class EventNameAndDescription extends StatefulWidget {
  final Function() onError;
  EventNameAndDescription({
    required this.onError,
    Key? key,
  }) : super(key: key);

  @override
  _EventDescriptionState createState() => _EventDescriptionState();
}

class _EventDescriptionState extends State<EventNameAndDescription> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.only(bottom: 30),
      child: BlocBuilder<EventCubit, EventState>(
        builder: (context, state) {
          if (state is EventStateNetworkFailure)
            return NetworkErrorWidget(
              state.message,
              onReload: widget.onError,
            );
          if (state is EventStateServerFailure)
            return ServerErrorWidget(
              state.message,
              onReload: widget.onError,
            );
          if (state is EventStateLoading || state is EventStateCreated)
            return Center(
              child: CircularProgressIndicator(),
            );
          return Column(
            children: [
              Flexible(
                flex: 2,
                child: TextFormField(
                  initialValue:
                      (state as EventStateUnfinished).createEventData.eventName,
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(15.0),
                        ),
                        borderSide: BorderSide.none),
                    filled: true,
                    hintStyle:
                        new TextStyle(color: Color.fromRGBO(255, 175, 150, 1)),
                    hintText: "Type event name...",
                    fillColor: Colors.white,
                  ),
                  maxLines: 15,
                  onChanged: (value) => BlocProvider.of<EventCubit>(context)
                      .eventNameChanged(value),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Flexible(
                flex: 7,
                child: TextFormField(
                  initialValue: (state as EventStateUnfinished)
                      .createEventData
                      .description,
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(15.0),
                        ),
                        borderSide: BorderSide.none),
                    filled: true,
                    hintStyle:
                        new TextStyle(color: Color.fromRGBO(255, 175, 150, 1)),
                    hintText: "Type event description...",
                    fillColor: Colors.white,
                  ),
                  maxLines: 15,
                  onChanged: (value) => BlocProvider.of<EventCubit>(context)
                      .eventDescriptionChanged(value),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

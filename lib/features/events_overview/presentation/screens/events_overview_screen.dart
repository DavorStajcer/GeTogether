import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/features/authentication/di/authentication_di.dart';
import 'package:get_together_app/features/events_overview/presentation/bloc/event_pick_cubit/event_pick_cubit_cubit.dart';
import 'package:get_together_app/features/events_overview/presentation/widgets/events_list.dart';
import 'package:get_together_app/features/events_overview/presentation/widgets/maps_view.dart';
import 'package:get_together_app/features/home/presentation/widgets/nav_bar_item.dart';

class EventsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<EventPickCubit>(
      create: (context) => getIt<EventPickCubit>(),
      child: Column(
        children: [
          Expanded(
            child: MapsView(),
          ),
          Expanded(
            child: Container(
              color: Color.fromRGBO(237, 231, 246, 1),
              padding: EdgeInsets.only(
                  bottom: NavBarMiddleItem.radius * 1.5,
                  top: NavBarMiddleItem.radius / 2),
              child: EventsList(),
            ),
          ),
        ],
      ),
    );
  }
}

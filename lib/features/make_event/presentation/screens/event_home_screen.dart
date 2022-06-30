import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/core/util/background_drawing.dart';
import 'package:get_together_app/core/widgets/get_together_title.dart';
import 'package:get_together_app/features/authentication/di/authentication_di.dart';
import 'package:get_together_app/features/home/presentation/bloc/nav_bar_cubit/nav_bar_cubit.dart';
import 'package:get_together_app/features/home/presentation/bloc/nav_bar_style_cubit/nav_bar_style_cubit.dart';
import 'package:get_together_app/features/home/presentation/screens/home_screen.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_card_order_cubit/event_card_order_cubit.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_cubit/event_cubit.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_cubit/event_state.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/maps_location_cubit/maps_location_cubit.dart';
import 'package:get_together_app/features/make_event/presentation/screens/choose_event_type_screen.dart';
import 'package:get_together_app/features/make_event/presentation/screens/choose_location_screen.dart';
import 'package:get_together_app/features/make_event/presentation/screens/event_details_screen.dart';

enum EventScreen { choose_event_type, choose_location, set_detailes }

class EventHomeScreen extends StatefulWidget {
  EventHomeScreen({Key? key}) : super(key: key);

  @override
  _EventHomeScreenState createState() => _EventHomeScreenState();
}

class _EventHomeScreenState extends State<EventHomeScreen> {
  late final PageController _pc;
  late final EventCubit eventCubit;
  late final MapsLocationCubit mapsLocationCubit;

  @override
  void initState() {
    _pc = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  void _goFoward() {
    _pc.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeOut);
  }

  void _onLocationError() {
    mapsLocationCubit.resetOnError();
    _pc.jumpToPage(_pc.initialPage);
  }

  void _onEventCreatingError() {
    _pc.jumpToPage(_pc.initialPage);
    mapsLocationCubit.resetOnError();
    eventCubit.resetOnError();
  }

  void _goBack() {
    _pc.previousPage(
        duration: Duration(milliseconds: 500), curve: Curves.easeOut);
  }

  void _finishEventMaking(BuildContext context) {
    BlocProvider.of<EventCubit>(context).createEvent();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EventCardOrderCubit>(
          create: (_) => getIt(),
        ),
        BlocProvider<EventCubit>(
          create: (_) => getIt(),
        ),
        BlocProvider<MapsLocationCubit>(
          create: (context) => getIt<MapsLocationCubit>(),
        ),
      ],
      child: SafeArea(
        child: Container(
          color: Color.fromRGBO(237, 231, 246, 1),
          child: CustomPaint(
            painter: BackgroundDrawing(context),
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: GetTogetherTitle(
                    textColor: Colors.white,
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.transparent,
                    child: Builder(builder: (context) {
                      eventCubit = BlocProvider.of<EventCubit>(context);
                      mapsLocationCubit =
                          BlocProvider.of<MapsLocationCubit>(context);
                      //  eventCubit.makeEventScreenInitialized();
                      return MultiBlocListener(
                        listeners: [
                          BlocListener<EventCubit, EventState>(
                              listener: (previousState, currentState) {
                            if (currentState is EventStateCreated) {
                              BlocProvider.of<NavBarCubit>(context)
                                  .changeScreen(HomeScreen.events_overview);
                              BlocProvider.of<NavBarStyleCubit>(context)
                                  .changeNavStyle(HomeScreen.events_overview);
                            }
                          }),
                          BlocListener<MapsLocationCubit, MapsLocationState>(
                              listener: (previouseState, currentState) {
                            log("CURRENT STATE MAPS LOCATION -> $currentState");
                            if (currentState is MapsLocationFailure)
                              BlocProvider.of<EventCubit>(context)
                                  .resetOnError();
                          }),
                        ],
                        child: PageView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: _pc,
                          children: [
                            ChooseEventTypeScreen(
                                goFowards: _goFoward, goBack: _goBack),
                            ChooseLocationScreen(
                              goFowards: _goFoward,
                              goBack: _goBack,
                              onError: _onLocationError,
                            ),
                            EventDetailsScreen(
                              createEvent: _finishEventMaking,
                              goBack: _goBack,
                              onError: _onEventCreatingError,
                            )
                          ],
                        ),
                      );
                    } /*  */
                        ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

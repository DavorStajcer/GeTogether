import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/features/chats_overview/presentation/bloc/chats_overivew_cubit/chats_overview_cubit.dart';
import 'package:get_together_app/features/events_overview/presentation/bloc/load_events_bloc/events_overview_bloc.dart';
import 'package:get_together_app/features/home/presentation/bloc/new_chats_bloc/new_chats_bloc.dart';
import 'package:get_together_app/features/home/presentation/bloc/new_notifications_bloc/new_notifications_bloc.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/maps_location_cubit/maps_location_cubit.dart';
import 'package:get_together_app/features/notifications_overview/presentation/bloc/event_answer_cubit/event_answer_cubit.dart';
import 'package:get_together_app/features/notifications_overview/presentation/bloc/notifications_bloc/notifications_bloc.dart';
import '../../../authentication/di/authentication_di.dart';
import '../../../authentication/presentation/bloc/auth_bloc/auth_bloc.dart';

import '../bloc/nav_bar_cubit/nav_bar_cubit.dart';
import '../bloc/nav_bar_style_cubit/nav_bar_style_cubit.dart';
import '../widgets/custom_nav_bar.dart';
import '../widgets/nav_bar_item.dart';

enum HomeScreen {
  events_overview,
  notifications_overview,
  make_event_HomeScreen,
  chats_overview,
  profile_overview,
}

class HomeScreenWidget extends StatelessWidget {
  static const String route = "/home_HomeScreen";

  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeScreenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => getIt<NavBarCubit>(),
            ),
            BlocProvider(
              create: (_) => getIt<NavBarStyleCubit>(),
            ),
            BlocProvider<AuthBloc>(
              create: (_) => getIt<AuthBloc>(),
            ),
            BlocProvider<MapsLocationCubit>(
              create: (_) => getIt<MapsLocationCubit>(),
            ),
            BlocProvider<EventsOverviewBloc>(
              create: (_) => getIt<EventsOverviewBloc>(),
            ),
            BlocProvider<ChatsOverviewCubit>(
              create: (_) => getIt<ChatsOverviewCubit>(),
            ),
            BlocProvider<NotificationsBloc>(
              create: (_) => getIt<NotificationsBloc>(),
            ),
            BlocProvider<EventAnswerCubit>(
              create: (_) => getIt<EventAnswerCubit>(),
            ),
            BlocProvider<NewNotificationsBloc>(
              create: (_) => getIt<NewNotificationsBloc>(),
            ),
            BlocProvider<NewChatsBloc>(
              create: (_) => getIt<NewChatsBloc>(),
            ),
          ],
          child: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  children: [
                    Container(
                      height: homeScreenSize.height - CustomNavBar.hight,
                      child: BlocBuilder<NavBarCubit, NavBarState>(
                        builder: (context, state) => state.screen,
                      ),
                    ),
                    CustomNavBar(screenSize: homeScreenSize),
                  ],
                ),
                NavBarMiddleItem(screen: HomeScreen.make_event_HomeScreen),
              ],
            ),
          )),
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_together_app/features/events_overview/presentation/screens/events_overview_screen.dart';
import 'package:get_together_app/features/make_event/presentation/screens/event_home_screen.dart';
import '../../../../chats_overview/presentation/screens/chats_overview_screen.dart';
import '../../screens/home_screen.dart';
import '../../../../notifications_overview/presentation/screens/notifications_overview_screen.dart';
import '../../../../profile_overview/presentation/screens/profile_overview_screen.dart';

part 'nav_bar_state.dart';

class NavBarCubit extends Cubit<NavBarState> {
  NavBarCubit() : super(NavBarEventsOverview());

  void changeScreen(HomeScreen screen) {
    switch (screen) {
      case HomeScreen.events_overview:
        emit(NavBarEventsOverview());
        break;
      case HomeScreen.notifications_overview:
        emit(NavBarNotificationsOverview());
        break;
      case HomeScreen.make_event_HomeScreen:
        emit(NavBarMakeEvent());
        break;
      case HomeScreen.chats_overview:
        emit(NavBarChatsOverview());
        break;
      case HomeScreen.profile_overview:
        emit(NavBarProfileOverview());
        break;
      default:
        emit(NavBarError());
    }
  }
}

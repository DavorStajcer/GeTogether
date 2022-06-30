part of 'nav_bar_cubit.dart';

abstract class NavBarState extends Equatable {
  final Widget screen;

  NavBarState(this.screen);

  @override
  List<Object> get props => [];
}

class NavBarEventsOverview extends NavBarState {
  NavBarEventsOverview() : super(EventsOverviewScreen());
}

class NavBarNotificationsOverview extends NavBarState {
  NavBarNotificationsOverview() : super(NotificationsOverviewScreen());
}

class NavBarMakeEvent extends NavBarState {
  NavBarMakeEvent() : super(EventHomeScreen());
}

class NavBarChatsOverview extends NavBarState {
  NavBarChatsOverview() : super(ChatsOverviewScreen());
}

class NavBarProfileOverview extends NavBarState {
  NavBarProfileOverview() : super(ProfileOverviewScreen());
}

class NavBarError extends NavBarState {
  NavBarError() : super(ProfileOverviewScreen());
}

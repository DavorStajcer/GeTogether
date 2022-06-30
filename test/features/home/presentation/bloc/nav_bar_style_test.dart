//@dart=2.6

import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/features/home/presentation/bloc/nav_bar_style_cubit/nav_bar_style_state.dart';
import 'package:get_together_app/features/home/presentation/screens/home_screen.dart';

void main() {
  NavBarStyleState navBarStyle;
  Map<HomeScreen, NavItemStyle> tItemsStyle;
  HomeScreen tPickedScreen;

  setUp(() {
    navBarStyle = NavBarStyleState();
    tPickedScreen = HomeScreen.make_event_HomeScreen;
    tItemsStyle = {
      HomeScreen.events_overview: NavItemPressed(),
      HomeScreen.notifications_overview: NavItemNotPressed(),
      HomeScreen.make_event_HomeScreen: NavItemNotPressed(),
      HomeScreen.chats_overview: NavItemNotPressed(),
      HomeScreen.profile_overview: NavItemNotPressed(),
    };
  });

  test("initial param should be good", () {
    expect(navBarStyle.itemsStyle, tItemsStyle);
  });

  test("copy with should be good", () {
    final navBarStyleNew = navBarStyle.copyWith(tPickedScreen);
    tItemsStyle.forEach((key, value) {
      tItemsStyle[key] = NavItemNotPressed();
    });
    tItemsStyle[tPickedScreen] = NavItemPressed();
    expect(navBarStyleNew.itemsStyle, tItemsStyle);
  });
}

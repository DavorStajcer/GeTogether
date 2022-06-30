import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../screens/home_screen.dart';

class NavBarStyleState extends Equatable {
  final Map<HomeScreen, NavItemStyle> itemsStyle;

  NavBarStyleState({Map<HomeScreen, NavItemStyle>? itemsStyle})
      : itemsStyle = itemsStyle ??
            {
              HomeScreen.events_overview: NavItemPressed(),
              HomeScreen.notifications_overview: NavItemNotPressed(),
              HomeScreen.make_event_HomeScreen: NavItemNotPressed(),
              HomeScreen.chats_overview: NavItemNotPressed(),
              HomeScreen.profile_overview: NavItemNotPressed(),
            };

  NavBarStyleState copyWith(HomeScreen screen) {
    Map<HomeScreen, NavItemStyle> newItemStyle = {
      HomeScreen.events_overview: NavItemNotPressed(),
      HomeScreen.notifications_overview: NavItemNotPressed(),
      HomeScreen.make_event_HomeScreen: NavItemNotPressed(),
      HomeScreen.chats_overview: NavItemNotPressed(),
      HomeScreen.profile_overview: NavItemNotPressed(),
    };
    newItemStyle.forEach((key, value) {
      newItemStyle[key] = NavItemNotPressed();
    });
    newItemStyle[screen] = NavItemPressed();
    return NavBarStyleState(itemsStyle: newItemStyle);
  }

  @override
  List<Object?> get props => [
        itemsStyle[HomeScreen.events_overview],
        itemsStyle[HomeScreen.notifications_overview],
        itemsStyle[HomeScreen.make_event_HomeScreen],
        itemsStyle[HomeScreen.chats_overview],
        itemsStyle[HomeScreen.profile_overview],
      ];
}

abstract class NavItemStyle extends Equatable {
  final Color color;
  final double iconSize;
  NavItemStyle(this.color, this.iconSize);

  @override
  List<Object?> get props => [color.value, iconSize];
}

class NavItemPressed extends NavItemStyle {
  NavItemPressed()
      : super(
          Color.fromRGBO(40, 53, 147, 1),
          45,
        );
}

class NavItemNotPressed extends NavItemStyle {
  NavItemNotPressed()
      : super(
          Color.fromRGBO(144, 144, 144, 1),
          35,
        );
}

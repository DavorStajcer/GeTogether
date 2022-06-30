//@dart=2.6

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/features/home/presentation/bloc/nav_bar_style_cubit/nav_bar_style_cubit.dart';
import 'package:get_together_app/features/home/presentation/bloc/nav_bar_style_cubit/nav_bar_style_state.dart';
import 'package:get_together_app/features/home/presentation/screens/home_screen.dart';

void main() {
  NavBarStyleCubit navBarStyleCubit;
  HomeScreen tPickedScreen;

  setUp(() {
    navBarStyleCubit = NavBarStyleCubit();
    tPickedScreen = HomeScreen.make_event_HomeScreen;
  });

  test("initla state should be good", () {
    expect(navBarStyleCubit.state, NavBarStyleState());
  });

  blocTest("should return good order",
      build: () => navBarStyleCubit,
      act: (cubit) => (cubit as NavBarStyleCubit).changeNavStyle(tPickedScreen),
      expect: () => [NavBarStyleState().copyWith(tPickedScreen)]);
}

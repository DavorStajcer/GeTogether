import 'package:flutter_bloc/flutter_bloc.dart';
import 'nav_bar_style_state.dart';
import '../../screens/home_screen.dart';

class NavBarStyleCubit extends Cubit<NavBarStyleState> {
  NavBarStyleCubit() : super(NavBarStyleState());

  void changeNavStyle(HomeScreen pickedScreen) {
    emit(state.copyWith(pickedScreen));
  }
}

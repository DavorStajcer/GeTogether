import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/features/authentication/domain/entities/user_data.dart';
import 'package:get_together_app/features/authentication/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:get_together_app/features/make_event/presentation/widgets/event_button.dart';
import 'package:get_together_app/features/profile_overview/presentation/bloc/profile_screen_cubit/profile_screen_cubit.dart';
import 'package:get_together_app/features/user_events_overview/presentation/screens/user_events_screen.dart';

class UserEventsAndLogOut extends StatelessWidget {
  final Size screenSize;
  final ProfileScreenState currentState;
  const UserEventsAndLogOut(
      {Key? key, required this.screenSize, required this.currentState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.125),
        child: _mapStateToWidget(context, currentState),
      ),
    );
  }
}

Widget _mapStateToWidget(BuildContext context, ProfileScreenState state) {
  if (state is ProfileScreenView)
    return _getViewWidget(context);
  else if (state is ProfileScreenLoading)
    return _getLoadingWidget(context);
  else
    return _getEditWidget(context, (state as ProfileScreenEdit).lastUserData);
}

Widget _getLoadingWidget(BuildContext context) =>
    _getViewWidget(context, isLoading: true);

Widget _getViewWidget(BuildContext context, {bool isLoading = false}) {
  return Row(
    children: [
      Flexible(
        flex: 2,
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          child: isLoading
              ? CircularProgressIndicator()
              : EventButton(
                  text: "Your events",
                  navigate: () {
                    Navigator.of(context).pushNamed(UserEventsScreen.route);
                  },
                ),
        ),
      ),
      Flexible(
        flex: 1,
        child: Container(),
      ),
      Flexible(
          flex: 2,
          child: Container(
            alignment: Alignment.center,
            child: isLoading
                ? CircularProgressIndicator()
                : IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
                      /*           if (ModalRoute.of(context)!.settings.name != "/")
                        Navigator.of(context).pop(); */
                    },
                  ),
          ))
    ],
  );
}

Widget _getEditWidget(BuildContext context, UserDataPublic userData) {
  return Container(
    alignment: Alignment.center,
    height: double.infinity,
    child: EventButton(
      text: "Submit changes",
      buttonColor: Theme.of(context).primaryColor.withOpacity(0.6),
      textColor: Colors.white,
      navigate: () {
        print("PRESED");
        BlocProvider.of<ProfileScreenCubit>(context).submitChanges(userData);
      },
    ),
  );
}

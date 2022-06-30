import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/form_bloc/form_bloc.dart';
import '../bloc/form_bloc/from_state.dart';
import '../bloc/form_bloc/form_event.dart';

class BottomAuthPicker extends StatelessWidget {
  final Size screenSize;

  const BottomAuthPicker(this.screenSize, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, AuthFormState>(builder: (context, state) {
      return Container(
        height: screenSize.height * 0.1,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                child: Container(
                  height: double.infinity,
                  decoration: _getLogInDecoration(state),
                  alignment: Alignment.center,
                  child: Text(
                    "Log in",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white70,
                    ),
                  ),
                ),
                onTap: () {
                  if (state is SignUpForm)
                    BlocProvider.of<FormBloc>(context).add(FormTypeChanged());
                },
              ),
            ),
            Expanded(
              child: GestureDetector(
                  child: Container(
                    height: double.infinity,
                    decoration: _getSingUpDecoration(context, state),
                    alignment: Alignment.center,
                    child: Text(
                      "Sign Up",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  onTap: () {
                    if (state is LogInForm) {
                      print("PRESSED");
                      BlocProvider.of<FormBloc>(context).add(FormTypeChanged());
                    }
                  }),
            ),
          ],
        ),
      );
    });
  }

  BoxDecoration _getSingUpDecoration(
          BuildContext context, AuthFormState state) =>
      BoxDecoration(
        border: Border(
          top: BorderSide(width: 2.0, color: Colors.white54),
          left: BorderSide(width: 1.0, color: Colors.white54),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            (state is SignUpForm)
                ? Color.fromRGBO(158, 158, 158, 1).withOpacity(0.2)
                : Colors.transparent,
            (state is SignUpForm)
                ? Theme.of(context).primaryColor.withOpacity(0.4)
                : Colors.transparent,
            (state is SignUpForm)
                ? Theme.of(context).primaryColor.withOpacity(0.6)
                : Colors.transparent,
          ],
        ),
      );

  BoxDecoration _getLogInDecoration(AuthFormState state) => BoxDecoration(
        border: Border(
          top: BorderSide(width: 2.0, color: Colors.white54),
          right: BorderSide(width: 1.0, color: Colors.white54),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            (state is LogInForm)
                ? Color.fromRGBO(158, 158, 158, 1).withOpacity(0.2)
                : Colors.transparent,
            (state is LogInForm)
                ? Color.fromRGBO(158, 158, 158, 1)
                : Colors.transparent,
          ],
        ),
      );
}

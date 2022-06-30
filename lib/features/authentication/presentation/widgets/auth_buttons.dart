import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/features/authentication/presentation/bloc/form_bloc/form_event.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/form_bloc/form_bloc.dart';
import '../bloc/form_bloc/from_state.dart';
import '../models/auth_param.dart';

class AuthButtons extends StatelessWidget {
  final double horizontalPadding;
  AuthButtons(this.horizontalPadding);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, AuthFormState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              AuthenticateButton(state),
              ChangeAuthModeButton(state),
            ],
          ),
        );
      },
    );
  }
}

class AuthenticateButton extends StatelessWidget {
  final AuthFormState authFormState;
  const AuthenticateButton(
    this.authFormState, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        child: Text(
          (authFormState is LogInForm) ? "Log in" : "Sing up",
          style: TextStyle(color: Colors.white70),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) =>
              (authFormState is ValidForm)
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor.withOpacity(0.2)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(18),
              ),
            ),
          ),
        ),
        onPressed: !(authFormState is ValidForm)
            ? null
            : () async {
                if (authFormState is ValidLoginForm)
                  BlocProvider.of<AuthBloc>(context).add(
                    LogInEvent(
                      LogInParameters(
                        email: authFormState.email.value!,
                        password: authFormState.password.value!,
                      ),
                    ),
                  );
                else
                  BlocProvider.of<AuthBloc>(context).add(
                    SignUpEvent(
                      SignUpParameters(
                        email: (authFormState as ValidSignUpForm).email.value!,
                        password: authFormState.password.value!,
                        username:
                            (authFormState as ValidSignUpForm).username.value!,
                        image: (authFormState as ValidSignUpForm).image!,
                      ),
                    ),
                  );
              },
      ),
    );
  }
}

class ChangeAuthModeButton extends StatelessWidget {
  final AuthFormState authFormState;
  const ChangeAuthModeButton(this.authFormState, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => BlocProvider.of<FormBloc>(context).add(
        FormTypeChanged(),
      ),
      child: Text(
        (authFormState is LogInForm) ? "Sign up instead" : "Log in instead",
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

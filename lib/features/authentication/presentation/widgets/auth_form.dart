import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/form_bloc/form_bloc.dart';
import '../bloc/form_bloc/from_state.dart';

import 'email_field.dart';
import 'pick_image.dart';
import 'confirm_password_field.dart';
import 'password_field.dart';
import 'username_field.dart';

class AuthForm extends StatelessWidget {
  final Size screenSize;
  final double horizontalPadding;

  AuthForm({
    required this.screenSize,
    required this.horizontalPadding,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, AuthFormState>(
      builder: (context, state) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
            ),
            child:
                (state is LogInForm) ? LogInFormWidget() : SingUpFormWidget(),
          ),
        );
      },
    );
  }
}

class LogInFormWidget extends StatelessWidget {
  const LogInFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        EmailField(),
        SizedBox(
          height: 15,
        ),
        PasswordField(),
      ],
    );
  }
}

class SingUpFormWidget extends StatelessWidget {
  const SingUpFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("FORM BUILD");
    return Container(
      child: Column(
        children: [
          PickImage(),
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              UsernameField(),
              SizedBox(
                height: 15,
              ),
              EmailField(),
              SizedBox(
                height: 15,
              ),
              PasswordField(),
              SizedBox(
                height: 15,
              ),
              ConfirmPasswordField(),
            ],
          ),
        ],
      ),
    );
  }
}

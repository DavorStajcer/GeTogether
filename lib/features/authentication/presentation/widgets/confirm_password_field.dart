import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/form_bloc/form_bloc.dart';
import '../bloc/form_bloc/from_state.dart';
import '../bloc/form_bloc/form_event.dart';

class ConfirmPasswordField extends StatelessWidget {
  const ConfirmPasswordField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<FormBloc, AuthFormState>(
        builder: (context, state) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: "Confirm password",
              labelStyle: TextStyle(color: Colors.white70),
              errorText: (state as SignUpForm).confirmPassword.errorMessage,
              icon: Icon(
                Icons.verified_sharp,
                color: Theme.of(context).primaryColor,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
              ),
            ),
            obscureText: true,
            onChanged: (value) {
              BlocProvider.of<FormBloc>(context)
                  .add(ConfirmPasswordChanged(value));
            },
            style: TextStyle(color: Colors.white70),
          );
        },
      ),
    );
  }
}

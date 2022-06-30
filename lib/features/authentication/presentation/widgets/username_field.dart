import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/form_bloc/form_bloc.dart';
import '../bloc/form_bloc/from_state.dart';
import '../bloc/form_bloc/form_event.dart';

class UsernameField extends StatelessWidget {
  const UsernameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, AuthFormState>(
      builder: (context, state) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: "Username",
            labelStyle: TextStyle(color: Colors.white70),
            errorText: (state as SignUpForm).username.errorMessage,
            icon: Icon(
              Icons.person,
              color: Theme.of(context).primaryColor,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white70),
            ),
          ),
          onChanged: (value) {
            BlocProvider.of<FormBloc>(context).add(UsernameChanged(value));
          },
          style: TextStyle(color: Colors.white70),
        );
      },
    );
  }
}

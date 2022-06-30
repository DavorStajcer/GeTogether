import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/form_bloc/form_bloc.dart';
import '../bloc/form_bloc/from_state.dart';
import '../bloc/form_bloc/form_event.dart';

class EmailField extends StatelessWidget {
  const EmailField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<FormBloc, AuthFormState>(
        builder: (context, state) {
          return TextFormField(
            initialValue: state.email.value,
            decoration: InputDecoration(
              labelText: "Email",
              errorText: state.email.errorMessage,
              labelStyle: TextStyle(color: Colors.white70),
              icon: Icon(
                Icons.email,
                color: Theme.of(context).primaryColor,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
              ),
            ),
            onChanged: (value) {
              BlocProvider.of<FormBloc>(context).add(EmailChanged(value));
            },
            style: TextStyle(color: Colors.white,),
          );
        },
      ),
    );
  }
}

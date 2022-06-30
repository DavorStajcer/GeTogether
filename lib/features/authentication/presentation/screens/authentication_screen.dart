import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/features/authentication/presentation/widgets/auth_background.dart';
import '../../di/authentication_di.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/form_bloc/form_bloc.dart';
import '../widgets/auth_buttons.dart';
import '../widgets/auth_form.dart';

class AuthScreen extends StatelessWidget {
  static final String route = "/auth_screen";
  AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double horizontalPadding = screenSize.width * 0.07;

    return Scaffold(
      body: SingleChildScrollView(
        child: BlocProvider<FormBloc>(
          create: (_) => getIt<FormBloc>(),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: screenSize.height),
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) async {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                if (state is AuthFailed) {
                  await showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                            content: Text(state.message),
                            actions: [
                              TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(),
                                  child: Text("Ok"))
                            ],
                          ));
                }
              },
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  AuthBackground(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AuthForm(
                        screenSize: screenSize,
                        horizontalPadding: horizontalPadding,
                      ),
                      AuthButtons(horizontalPadding),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

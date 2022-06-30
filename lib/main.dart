import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/features/chats_overview/di/chats_di.dart';
import 'package:get_together_app/features/chats_overview/presentation/screens/chat_screen.dart';
import 'package:get_together_app/features/events_overview/di/event_overview_di.dart';
import 'package:get_together_app/features/make_event/di/make_event_di.dart';
import 'package:get_together_app/features/notifications_overview/di/notifications_di.dart';
import 'package:get_together_app/features/profile_overview/di/profile_di.dart';
import 'package:get_together_app/features/profile_overview/presentation/bloc/profile_screen_cubit/profile_screen_cubit.dart';
import 'package:get_together_app/features/single_event_overview/di/single_event_overview_di.dart';
import 'package:get_together_app/features/single_event_overview/presentation/screens/single_event_screen.dart';
import 'package:get_together_app/features/user_events_overview/di/user_events_di.dart';
import 'package:get_together_app/features/user_events_overview/presentation/screens/user_events_screen.dart';
import 'features/authentication/di/authentication_di.dart';
import 'features/authentication/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'features/authentication/presentation/bloc/auth_check_bloc/authentication_check_bloc.dart';
import 'features/authentication/presentation/screens/authentication_screen.dart';
import 'features/home/di/home_di.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/authentication/presentation/screens/splash_screen.dart';
import 'package:flutter/services.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  init(); //init getIt
  initHomeDi();
  initMakeEventDi();
  initProfileDi();
  initEventsOverviewDi();
  initNotificationsDi();
  initSingleEventDi();
  initChatDi();
  initUserEventsDi();
  runApp(GetTogetherApp());
}

class GetTogetherApp extends StatefulWidget {
  const GetTogetherApp({Key? key}) : super(key: key);

  @override
  _GetTogetherAppState createState() => _GetTogetherAppState();
}

class _GetTogetherAppState extends State<GetTogetherApp> {
  AuthenticationCheckBloc? bloc;

  @override
  void initState() {
    super.initState();
    bloc = getIt<AuthenticationCheckBloc>();
    if (bloc != null) bloc!.add(ApplicationStarted());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          //primaryColor: Color.fromRGBO(255, 109, 64, 1),
          primaryColor: Color.fromRGBO(255, 110, 64, 1),
          accentColor: Color.fromRGBO(255, 109, 64, 1),
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (context) => getIt<AuthBloc>(),
            ),
            BlocProvider<AuthenticationCheckBloc>(
              create: (context) => getIt<AuthenticationCheckBloc>(),
            ),
            BlocProvider<ProfileScreenCubit>(
              create: (_) => getIt<ProfileScreenCubit>(),
            ),
          ],
          child:
              BlocConsumer<AuthenticationCheckBloc, AuthenticationCheckState>(
            bloc: bloc,
            listener: (context, state) {
              if (state is ServerErrorState)
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text("Automatic atuhentication failed."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("Ok"),
                            ),
                          ],
                        ));
            },
            builder: (context, state) {
              if (state is AuthenticationCheckInitialState)
                return SplashScreen();

              if (state is UserLoggedInState) return HomeScreenWidget();
              return AuthScreen();
            },
          ),
        ),
        routes: {
          HomeScreenWidget.route: (_) => HomeScreenWidget(),
          AuthScreen.route: (_) => AuthScreen(),
          UserEventsScreen.route: (_) => UserEventsScreen(),
          SingleEventScreen.route: (_) => SingleEventScreen(),
          ChatScreen.route: (_) => ChatScreen(),
        });
  }
}

/* 

 */

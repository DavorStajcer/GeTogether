import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/network.dart/network_info.dart';
import '../../../domain/usecases/listen_to_auth_state_changes.dart';

part 'authentication_check_event.dart';
part 'authentication_check_state.dart';

class AuthenticationCheckBloc
    extends Bloc<AuthenticationCheckEvent, AuthenticationCheckState> {
  final NetworkInfo networkInfo;
  final ListenToAuthStateChanges listenToAuthStateChanges;

  AuthenticationCheckBloc(
      {required this.networkInfo, required this.listenToAuthStateChanges})
      : super(AuthenticationCheckInitialState());

  @override
  Stream<AuthenticationCheckState> mapEventToState(
    AuthenticationCheckEvent event,
  ) async* {
    if (event is ApplicationStarted) {
      yield AuthenticationCheckInitialState();
      listenToAuthStateChanges(this);
    }
    if (event is AuthStateChanged) {
      yield* event.response.fold((failure) async* {
        yield ServerErrorState();
      }, (user) async* {
        if (user == null)
          yield UserNotLoggedInState();
        else
          yield UserLoggedInState();
      });
    }
  }
}

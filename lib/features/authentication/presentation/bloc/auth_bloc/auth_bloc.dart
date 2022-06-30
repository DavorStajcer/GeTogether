import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/error/success.dart';
import '../../../domain/usecases/log_user_in.dart';
import '../../../domain/usecases/sign_user_in.dart';
import '../../../domain/usecases/sign_user_out.dart';
import '../../models/auth_param.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LogUserIn logUserIn;
  final SignUserIn signUserIn;
  final SignUserOut signUserOut;

  AuthBloc({
    required this.logUserIn,
    required this.signUserIn,
    required this.signUserOut,
  }) : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    yield AuthLoading();
    Either<Failure, Success> response;

    if (event is SignOutEvent)
      response = await signUserOut(NoParameters());
    else if (event is LogInEvent)
      response = await logUserIn(event.authParam);
    else
      response = await signUserIn((event as SignUpEvent).authParam);

    yield* _mapRepsonseToState(response);
  }

  Stream<AuthState> _mapRepsonseToState(
      Either<Failure, Success> response) async* {
    yield* response.fold((
      failure,
    ) async* {
      String errorMessage;
      if (failure is NetworkFailure)
        errorMessage = "Network failure";
      else if (failure is AuthenticationFailure)
        errorMessage = failure.message;
      else
        errorMessage = "Error occured";
      yield AuthFailed(errorMessage);
    }, (
      success,
    ) async* {
      yield AuthSuccessfull();
    });
  }
}

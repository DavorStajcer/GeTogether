//@dart=2.6

import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/error/success.dart';

import 'package:get_together_app/features/authentication/domain/usecases/log_user_in.dart';
import 'package:get_together_app/features/authentication/domain/usecases/sign_user_in.dart';
import 'package:get_together_app/features/authentication/domain/usecases/sign_user_out.dart';
import 'package:get_together_app/features/authentication/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:get_together_app/features/authentication/presentation/models/auth_param.dart';
import 'package:mockito/mockito.dart';

class LogUserInMock extends Mock implements LogUserIn {}

class SignUserInMock extends Mock implements SignUserIn {}

class SignUserOutMock extends Mock implements SignUserOut {}

void main() {
  LogUserInMock logUserInMock;
  SignUserInMock signUserInMock;
  SignUserOutMock signUserOutMock;
  AuthBloc authBloc;
  String tEmail;
  String tUsername;
  String tPassword;
  String tErrorMessage;
  LogInParameters tLogInParam;
  SignUpParameters tSignUpParam;
  String tPath;
  File tImge;

  setUp(() {
    logUserInMock = LogUserInMock();
    signUserInMock = SignUserInMock();
    signUserOutMock = SignUserOutMock();
    authBloc = AuthBloc(
      logUserIn: logUserInMock,
      signUserIn: signUserInMock,
      signUserOut: signUserOutMock,
    );
    tEmail = "testEmail";
    tUsername = "tUsername";
    tPassword = "tPassword";
    tErrorMessage = "Erorr test";
    tLogInParam = LogInParameters(email: tEmail, password: tPassword);
    tPath = "testPath";
    tImge = File(tPath);
    tSignUpParam = SignUpParameters(
        email: tEmail, password: tPassword, username: tUsername, image: tImge);
  });

  test("inital state should be AuthIntial", () {
    expect(authBloc.state, AuthInitial());
  });

  blocTest(
      "state should emitt AuthSuccessfull if user is logged in successfully",
      build: () {
        when(logUserInMock.call(any))
            .thenAnswer((realInvocation) async => Right(Success()));
        return authBloc;
      },
      act: (dynamic testBloc) {
        testBloc.add(
            LogInEvent(LogInParameters(email: tEmail, password: tPassword)));
      },
      expect: () => [AuthLoading(), AuthSuccessfull()],
      verify: (dynamic testBloc) {
        verify(logUserInMock
            .call(LogInParameters(email: tEmail, password: tPassword)));
      });

  blocTest("should emit AuthenticationFailure when loggin is not successfull",
      build: () {
        when(logUserInMock(tLogInParam)).thenAnswer((realInvocation) async =>
            Left(AuthenticationFailure(message: tErrorMessage)));
        return authBloc;
      },
      act: (dynamic testBloc) {
        testBloc.add(
            LogInEvent(LogInParameters(email: tEmail, password: tPassword)));
      },
      expect: () => [AuthLoading(), AuthFailed(tErrorMessage)],
      verify: (dynamic testBloc) {
        verify(logUserInMock(tLogInParam));
      });

  blocTest("should emit AuthenticationSuccess when sigin in is successfull",
      build: () {
        when(signUserInMock(tSignUpParam))
            .thenAnswer((realInvocation) async => Right(Success()));
        return authBloc;
      },
      act: (dynamic testBloc) {
        testBloc.add(SignUpEvent(tSignUpParam));
      },
      expect: () => [AuthLoading(), AuthSuccessfull()],
      verify: (dynamic testBloc) {
        verify(signUserInMock(tSignUpParam));
      });

  blocTest("should emit AuthFailed when sign in is not successfull",
      build: () {
        when(signUserInMock(tSignUpParam)).thenAnswer((realInvocation) async =>
            Left(AuthenticationFailure(message: tErrorMessage)));
        return authBloc;
      },
      act: (dynamic testBloc) {
        testBloc.add(SignUpEvent(tSignUpParam));
      },
      expect: () => [AuthLoading(), AuthFailed(tErrorMessage)],
      verify: (dynamic testBloc) {
        verify(signUserInMock(tSignUpParam));
      });
}

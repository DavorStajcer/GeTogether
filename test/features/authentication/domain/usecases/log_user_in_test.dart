//@dart=2.6

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/error/success.dart';

import 'package:get_together_app/features/authentication/domain/repository/user_auth_repository.dart';
import 'package:get_together_app/features/authentication/domain/usecases/log_user_in.dart';
import 'package:get_together_app/features/authentication/presentation/models/auth_param.dart';
import 'package:mockito/mockito.dart';

class UserRepositoryMock extends Mock implements UserAuthRepository {}

void main() {
  UserRepositoryMock userRepositoryMock;
  LogUserIn logUserIn;
  String tEmail;
  String tPassword;
  LogInParameters tLogInParam;

  setUp(() {
    userRepositoryMock = UserRepositoryMock();
    logUserIn = LogUserIn(userRepositoryMock);
    tEmail = "testEmail";
    tPassword = "tPassword";
    tLogInParam = LogInParameters(email: tEmail, password: tPassword);
  });
  group("no errors", () {
    test("should return Success when user is logged in", () async {
      when(userRepositoryMock.logIn(tLogInParam))
          .thenAnswer((realInvocation) async => Right(Success()));

      final Either<Failure, Success> response =
          await logUserIn(LogInParameters(email: tEmail, password: tPassword));

      expect(response, Right(Success()));
      verify(userRepositoryMock.logIn(tLogInParam));
    });
  });
  group("error", () {
    test("should return AuthenticatioFailure", () async {
      when(userRepositoryMock.logIn(tLogInParam)).thenAnswer(
          (realInvocation) async => Left(AuthenticationFailure(message: "")));

      final Either<Failure, Success> response =
          await logUserIn(LogInParameters(email: tEmail, password: tPassword));

      expect(response, Left(AuthenticationFailure(message: "")));
      verify(userRepositoryMock.logIn(tLogInParam));
    });
  });
}

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/success.dart';
import '../../presentation/models/auth_param.dart';

abstract class UserAuthRepository {
  Future<Either<Failure, Success>> logIn(LogInParameters parameters);
  Future<Either<Failure, Success>> signUp(SignUpParameters parameters);
  Stream<User?> listenToAuthStream();
  Future<Either<Failure, Success>> signOut();
}

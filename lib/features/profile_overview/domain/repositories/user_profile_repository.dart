import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/features/authentication/domain/entities/user_data.dart';

abstract class UserProfileRepository {
  Future<Either<Failure, UserDataPublic>> getUserProfileData(String? userId);
  Future<Either<Failure, Success>> saveUserData(UserDataPublic userProfileData);
  Future<Either<Failure, String>> saveUserImageToFirebaseStorage(String image);
}

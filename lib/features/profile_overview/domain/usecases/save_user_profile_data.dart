import 'package:get_together_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/features/authentication/domain/entities/user_data.dart';
import 'package:get_together_app/features/profile_overview/domain/repositories/user_profile_repository.dart';

class SaveUserProfileData extends Usecase<Success, UserDataPublic> {
  final UserProfileRepository userProfileRepository;
  SaveUserProfileData({required this.userProfileRepository});

  @override
  Future<Either<Failure, Success>> call(UserDataPublic userProfileData) async {
    return await userProfileRepository.saveUserData(userProfileData);
  }
}

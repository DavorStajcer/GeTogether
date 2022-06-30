import 'package:get_together_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/features/authentication/domain/entities/user_data.dart';
import 'package:get_together_app/features/profile_overview/domain/repositories/user_profile_repository.dart';

class GetUserProfileData extends Usecase<UserDataPublic, String> {
  final UserProfileRepository userProfileRepository;
  GetUserProfileData({required this.userProfileRepository});

  @override
  Future<Either<Failure, UserDataPublic>> call(String? userId) async {
    return await userProfileRepository.getUserProfileData(userId);
  }
}

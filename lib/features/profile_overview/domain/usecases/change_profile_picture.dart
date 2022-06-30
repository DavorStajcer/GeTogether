import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/features/profile_overview/domain/repositories/user_profile_repository.dart';

class ChangeProfilePicture extends Usecase<String, String> {
  final UserProfileRepository userProfileRepository;
  ChangeProfilePicture({required this.userProfileRepository});
  @override
  Future<Either<Failure, String>> call(String image) async =>
      await userProfileRepository.saveUserImageToFirebaseStorage(image);
}

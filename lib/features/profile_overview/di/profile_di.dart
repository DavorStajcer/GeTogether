import 'package:get_together_app/features/authentication/di/authentication_di.dart';
import 'package:get_together_app/features/profile_overview/data/repositories/user_profile_repository_impl.dart';
import 'package:get_together_app/features/profile_overview/domain/repositories/user_profile_repository.dart';
import 'package:get_together_app/features/profile_overview/domain/usecases/change_profile_picture.dart';
import 'package:get_together_app/features/profile_overview/domain/usecases/get_user_profile_data.dart';
import 'package:get_together_app/features/profile_overview/domain/usecases/save_user_profile_data.dart';
import 'package:get_together_app/features/profile_overview/presentation/bloc/profile_screen_cubit/profile_screen_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void initProfileDi() {
  getIt.registerSingleton<UserProfileRepository>(
      UserProfileRepositoryImpl(networkInfo: getIt()));
  getIt.registerSingleton(GetUserProfileData(userProfileRepository: getIt()));
  getIt.registerSingleton(SaveUserProfileData(userProfileRepository: getIt()));
  getIt.registerSingleton(ChangeProfilePicture(userProfileRepository: getIt()));
  getIt.registerFactory(() => ProfileScreenCubit(getIt(), getIt(), getIt()));
}

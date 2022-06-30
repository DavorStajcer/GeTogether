import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/features/authentication/data/models/user_data_model.dart';
import 'package:get_together_app/features/authentication/domain/entities/user_data.dart';
import 'package:get_together_app/features/profile_overview/domain/usecases/change_profile_picture.dart';
import 'package:get_together_app/features/profile_overview/domain/usecases/get_user_profile_data.dart';
import 'package:get_together_app/features/profile_overview/domain/usecases/save_user_profile_data.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_screen_state.dart';

class ProfileScreenCubit extends Cubit<ProfileScreenState> {
  final GetUserProfileData _getUserProfileData;
  final SaveUserProfileData _saveUserProfileData;
  final ChangeProfilePicture changeProfilePicture;
  final ImagePicker imagePicker;
  ProfileScreenCubit(this._getUserProfileData, this._saveUserProfileData,
      this.changeProfilePicture)
      : imagePicker = ImagePicker(),
        super(ProfileScreenLoading());

  void editProfile(UserDataPublic dataBeforeEdit) {
    emit(ProfileScreenEdit(lastUserData: dataBeforeEdit));
  }

  void getScreenData({String? userId}) async {
    if (!(state is ProfileScreenLoading)) emit(ProfileScreenLoading());
    final response = await _getUserProfileData.call(userId);
    response.fold(
      (failure) {
        if (failure is NetworkFailure)
          emit(ProfileScreennNetworkError(message: failure.message));
        else
          emit(ProfileScreenServerError(message: failure.message));
      },
      (userProfileData) =>
          emit(ProfileScreenView(userProfileData: userProfileData)),
    );
  }

  void submitChanges(UserDataPublic userProfileData) async {
    emit(ProfileScreenLoading());
    final response = await _saveUserProfileData(userProfileData);
    response.fold(
      (failure) {
        if (failure is NetworkFailure)
          emit(ProfileScreennNetworkError(message: failure.message));
        else
          emit(ProfileScreenServerError(message: failure.message));
      },
      (success) => emit(
        ProfileScreenView(
          userProfileData: userProfileData,
        ),
      ),
    );
  }

  void usernameChanged(String newValue) {
    emit((state as ProfileScreenEdit).copyWith(username: newValue));
  }

  void cityChanged(String newValue) {
    emit((state as ProfileScreenEdit).copyWith(city: newValue));
  }

  void countryChanged(String newValue) {
    emit((state as ProfileScreenEdit).copyWith(country: newValue));
  }

  void descriptionChanged(String newValue) {
    emit((state as ProfileScreenEdit).copyWith(description: newValue));
  }

  void changeImage() async {
    final PickedFile? image = await imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 70);
    if (image == null) return;
    final ProfileScreenEdit editState = state as ProfileScreenEdit;
    emit(ProfileScreenLoading());
    final response = await changeProfilePicture(image.path);
    response.fold((failure) {
      if (failure is NetworkFailure)
        emit(ProfileScreennNetworkError(message: failure.message));
      else
        emit(ProfileScreenServerError(message: failure.message));
    }, (imageUrl) => emit(editState.copyWith(imageUrl: imageUrl)));
  }
}

//@dart=2.6

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/features/authentication/data/models/user_data_model.dart';
import 'package:get_together_app/features/profile_overview/domain/usecases/change_profile_picture.dart';
import 'package:get_together_app/features/profile_overview/domain/usecases/get_user_profile_data.dart';
import 'package:get_together_app/features/profile_overview/domain/usecases/save_user_profile_data.dart';
import 'package:get_together_app/features/profile_overview/presentation/bloc/profile_screen_cubit/profile_screen_cubit.dart';
import 'package:mockito/mockito.dart';

class GetUserProfileDataMock extends Mock implements GetUserProfileData {}

class SaveUserProfileDataMock extends Mock implements SaveUserProfileData {}

class ChangeProfilePictureMock extends Mock implements ChangeProfilePicture {}

void main() {
  GetUserProfileDataMock getUserProfileDataMock;
  SaveUserProfileDataMock saveUserProfileDataMock;
  ProfileScreenCubit profileScreenCubit;
  String tUserId;
  UserModelPublic tUserProfileData;
  UserModelPublic tUserProfileDataModified;
  ChangeProfilePictureMock changeProfilePictureMock;

  setUp(() {
    tUserId = "tUserId";
    tUserProfileData = UserModelPublic(
      userId: tUserId,
      username: "username",
      imageUrl: "imageUrl",
      city: "city",
      country: "country",
      description: "description",
      friendsCount: 1,
      rating: 1,
      numberOfVotes: 1,
    );
    tUserProfileDataModified = UserModelPublic(
      userId: tUserId,
      username: "modified",
      imageUrl: "modified",
      city: "modified",
      country: "modified",
      description: "modified",
      friendsCount: 0,
      rating: 0,
      numberOfVotes: 0,
    );
    getUserProfileDataMock = GetUserProfileDataMock();
    saveUserProfileDataMock = SaveUserProfileDataMock();
    changeProfilePictureMock = ChangeProfilePictureMock();
    profileScreenCubit = ProfileScreenCubit(
      getUserProfileDataMock,
      saveUserProfileDataMock,
      changeProfilePictureMock,
    );
  });

  test("Initial state should be ProfileScreenLoading", () {
    expect(profileScreenCubit.state, ProfileScreenLoading());
  });

  group("no errors", () {
    setUp(() {
      when(getUserProfileDataMock(tUserId))
          .thenAnswer((realInvocation) async => Right(tUserProfileData));
      when(saveUserProfileDataMock(any))
          .thenAnswer((realInvocation) async => Right(Success()));
    });

    //getScreendData()
    test("getScreenData() -> should call getUserProfileData ", () {
      profileScreenCubit.getScreenData(userId: tUserId);
      verify(getUserProfileDataMock.call(tUserId));
    });

    blocTest("getData() -> should emit ProfileScreenView ",
        build: () => profileScreenCubit,
        act: (cubit) =>
            (cubit as ProfileScreenCubit).getScreenData(userId: tUserId),
        expect: () => [
              ProfileScreenView(userProfileData: tUserProfileData),
            ]);

    //editProfile()
    blocTest("editProfile() -> should emit ProfileScreenEdit",
        build: () => profileScreenCubit,
        act: (cubit) {
          (cubit as ProfileScreenCubit).editProfile(tUserProfileData);
        },
        expect: () => [
              ProfileScreenEdit(lastUserData: tUserProfileData),
            ]);

    //submitChanges()
    test("submitChanges() -> should call saveUserProfileData usecase", () {
      profileScreenCubit.submitChanges(tUserProfileDataModified);
      verify(saveUserProfileDataMock.call(tUserProfileDataModified));
    });

    blocTest(
        "submitChanges() -> should emit ProfileScreenLoading and ProfileScreenView ",
        build: () => profileScreenCubit,
        act: (cubit) => (cubit as ProfileScreenCubit)
            .submitChanges(tUserProfileDataModified),
        expect: () => [
              ProfileScreenLoading(),
              ProfileScreenView(userProfileData: tUserProfileDataModified)
            ]);
  });

  group("errors", () {
    //getScreenData()
    blocTest("getScreenData() -> should emit ProfileScreenError",
        build: () {
          when(getUserProfileDataMock(any))
              .thenAnswer((realInvocation) async => Left(NetworkFailure()));
          return profileScreenCubit;
        },
        act: (cubit) =>
            (cubit as ProfileScreenCubit).getScreenData(userId: tUserId),
        expect: () => [
              isA<ProfileScreennNetworkError>(),
            ]);
    //submitChanges()
    blocTest("getScreenData() -> should emit ProfileScreenError",
        build: () {
          when(saveUserProfileDataMock(any))
              .thenAnswer((realInvocation) async => Left(NetworkFailure()));
          return profileScreenCubit;
        },
        act: (cubit) => (cubit as ProfileScreenCubit)
            .submitChanges(tUserProfileDataModified),
        expect: () => [
              ProfileScreenLoading(),
              isA<ProfileScreennNetworkError>(),
            ]);
  });
}

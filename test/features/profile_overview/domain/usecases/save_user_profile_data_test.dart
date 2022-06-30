//@dart=2.6

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/features/authentication/data/models/user_data_model.dart';
import 'package:get_together_app/features/profile_overview/domain/repositories/user_profile_repository.dart';
import 'package:get_together_app/features/profile_overview/domain/usecases/save_user_profile_data.dart';
import 'package:mockito/mockito.dart';

class UserProfileRepositoryMock extends Mock implements UserProfileRepository {}

void main() {
  UserProfileRepositoryMock userProfileRepositoryMock;
  SaveUserProfileData saveUserProfileData;
  UserModelPublic tUserProfileData;

  setUp(() {
    userProfileRepositoryMock = UserProfileRepositoryMock();
    saveUserProfileData = SaveUserProfileData(
      userProfileRepository: userProfileRepositoryMock,
    );
    tUserProfileData = UserModelPublic(
      userId: "tUserId",
      username: "username",
      imageUrl: "imageUrl",
      city: "city",
      country: "country",
      description: "description",
      friendsCount: 1,
      rating: 1,
      numberOfVotes: 1,
    );
  });

  group("no errors", () {
    setUp(() {
      when(userProfileRepositoryMock.saveUserData(tUserProfileData)).thenAnswer(
        (realInvocation) async => Right(Success()),
      );
    });

    test("Should make a call to repository", () async {
      await saveUserProfileData(tUserProfileData);
      verify(userProfileRepositoryMock.saveUserData(tUserProfileData));
    });

    test("Should return Success", () async {
      final response = await saveUserProfileData(tUserProfileData);
      expect(response, Right(Success()));
    });
  });

  group("errors", () {
    test("when Network error it should return Failure with message", () async {
      when(userProfileRepositoryMock.saveUserData(any)).thenAnswer(
        (realInvocation) async => Left(
          NetworkFailure(),
        ),
      );

      final response = await saveUserProfileData(tUserProfileData);
      expect(
        response,
        Left(
          NetworkFailure(),
        ),
      );
    });

    group("errors", () {
      test("when Server error it should return Failure with message", () async {
        when(userProfileRepositoryMock.saveUserData(any)).thenAnswer(
          (realInvocation) async => Left(
            ServerFailure(message: "tMessage"),
          ),
        );

        final response = await saveUserProfileData(tUserProfileData);
        expect(
          response,
          Left(
            ServerFailure(message: "tMessage"),
          ),
        );
      });
    });
  });
}

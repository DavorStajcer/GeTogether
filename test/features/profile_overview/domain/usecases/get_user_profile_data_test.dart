//@dart=2.6

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/features/authentication/data/models/user_data_model.dart';
import 'package:get_together_app/features/profile_overview/domain/repositories/user_profile_repository.dart';
import 'package:get_together_app/features/profile_overview/domain/usecases/get_user_profile_data.dart';
import 'package:mockito/mockito.dart';

class UserProfileRepositoryMock extends Mock implements UserProfileRepository {}

void main() {
  UserProfileRepositoryMock userProfileRepositoryMock;
  GetUserProfileData getUserProfileData;
  UserModelPublic tUserProfileData;
  String tUserId;

  setUp(() {
    userProfileRepositoryMock = UserProfileRepositoryMock();
    getUserProfileData =
        GetUserProfileData(userProfileRepository: userProfileRepositoryMock);
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
  });

  group("no errors", () {
    setUp(() {
      when(userProfileRepositoryMock.getUserProfileData(tUserId)).thenAnswer(
        (realInvocation) async => Right(tUserProfileData),
      );
    });

    test("Should make a call to repository", () async {
      await getUserProfileData(tUserId);
      verify(userProfileRepositoryMock.getUserProfileData(tUserId));
    });

    test("Should return UserProfileData", () async {
      final response = await getUserProfileData(tUserId);
      expect(response, Right(tUserProfileData));
    });
  });

  group("errors", () {
    test("when Network error it should return Failure with message", () async {
      when(userProfileRepositoryMock.getUserProfileData(tUserId)).thenAnswer(
        (realInvocation) async => Left(
          NetworkFailure(),
        ),
      );

      final response = await getUserProfileData(tUserId);
      expect(
        response,
        Left(
          NetworkFailure(),
        ),
      );
    });

    group("errors", () {
      test("when Server error it should return Failure with message", () async {
        when(userProfileRepositoryMock.getUserProfileData(tUserId)).thenAnswer(
          (realInvocation) async => Left(
            ServerFailure(message: "tMessage"),
          ),
        );

        final response = await getUserProfileData(tUserId);
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

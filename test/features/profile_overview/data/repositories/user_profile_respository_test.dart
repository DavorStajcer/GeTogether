//@dart=2.6

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/features/authentication/data/models/user_data_model.dart';
import 'package:get_together_app/features/profile_overview/data/repositories/user_profile_repository_impl.dart';
import 'package:get_together_app/features/profile_overview/domain/repositories/user_profile_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../../firebase_mock/firebase_service_mock.dart';
import '../../../../network_info_mock/network_info_mock.dart';

void main() {
  UserProfileRepository userProfileRepository;
  FirebaseServiceMock firebaseService;
  NetworkInfoMock networkInfoMock;
  UserModelPublic tUserProfileData;
  String tUserId;

  setUp(() {
    firebaseService = FirebaseServiceMock();
    networkInfoMock = NetworkInfoMock();
    userProfileRepository = UserProfileRepositoryImpl(
      networkInfo: networkInfoMock,
      firebaseAuth: firebaseService.firebaseAuthMock,
      firebaseFirestore: firebaseService.firebaseFirestoreMock,
      firebaseStorage: firebaseService.firebaseStorageMock,
    );
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
    firebaseService.setUpFirebaseAuth();
    firebaseService.setUpFirebaseFirestore();
    firebaseService.setUpFirebaseStorage();
    firebaseService.setUpFirestoreDocumentData(tUserProfileData.toJsonMap());
    firebaseService.setUpFirebaseUserId(tUserId);
  });

  group("get user profile data", () {
    group("no errors", () {
      setUp(() {
        networkInfoMock.setUpItHasConnection();
      });

      //getUserData()
      test("getUserData -> should return UserData", () async {
        firebaseService
            .setUpFirestoreDocumentData(tUserProfileData.toJsonMap());
        final response =
            await userProfileRepository.getUserProfileData(tUserId);

        expect(response, Right(tUserProfileData));
      });

      test("getUserData -> should make a call to firestore with given userId",
          () async {
        await userProfileRepository.getUserProfileData(tUserId);
        verify(firebaseService.firebaseFirestoreMock.collection("users"))
            .called(1);
      });

      //saveUserData()
      test("saveUserData -> should make a call to firebase firestore",
          () async {
        await userProfileRepository.saveUserData(tUserProfileData);
        verify(firebaseService.firebaseFirestoreMock.collection("users"))
            .called(1);
      });
      //saveUserData()
      /*    test("saveUserData -> should make a call to firebase storage", () async {
        await userProfileRepository.saveUserData(tUserProfileData);
        verify(firebaseService.firebaseStorageMock.ref()).called(1);
      }); */

      test("saveUserData -> should return Success", () async {
        final response =
            await userProfileRepository.saveUserData(tUserProfileData);
        expect(response, Right(Success()));
      });
    });

    group("errors", () {
      //getUserData()
      test(
          "getUserData -> should return NetworkFailure when there is no connection",
          () async {
        networkInfoMock.setUpNoConnection();
        final response =
            await userProfileRepository.getUserProfileData(tUserId);
        expect(response, Left(NetworkFailure()));
      });
      test("getUserData -> should call firebase firestore", () async {
        networkInfoMock.setUpItHasConnection();
        await userProfileRepository.getUserProfileData(tUserId);
        verify(firebaseService.firebaseFirestoreMock.collection("users"))
            .called(1);
      });

      test(
          "getUserData -> should return ServerFailure when getting data form firestore fails",
          () async {
        networkInfoMock.setUpItHasConnection();
        firebaseService.setUpFirebaseFirestoreError();
        final response =
            await userProfileRepository.getUserProfileData(tUserId);
        expect(response, Left(ServerFailure()));
      });

      //saveUserData()

      test(
          "saveUserData -> should return NetforkFailure when there is no connection",
          () async {
        networkInfoMock.setUpNoConnection();
        final response =
            await userProfileRepository.saveUserData(tUserProfileData);
        expect(response, Left(NetworkFailure()));
      });
      test(
          "saveUserData -> should return ServerFailure when failed to save to firebase firestore",
          () async {
        networkInfoMock.setUpItHasConnection();
        firebaseService.setUpFirebaseFirestoreError();
        final response =
            await userProfileRepository.saveUserData(tUserProfileData);
        expect(response, Left(ServerFailure()));
      });
    });
  });
}


  //Functions to make SharedPref Mock if needed

  /* void _goodSharedPrefGet() {
    when(sharedPreferencesMock.getString(any))
        .thenReturn(json.encode(tUserProfileData.toJsonMap()));
  }

  void _goodSharedPrefSet() {
    when(sharedPreferencesMock.setString(any, any))
        .thenAnswer((realInvocation) async => true); 
  }

  void _badSharedPrefSet() {
    when(sharedPreferencesMock.setString(any, any))
        .thenAnswer((realInvocation) async => false);
  }

  void _gettingStringFromSharedPrefReturnNull() {
    when(sharedPreferencesMock.getString(any)).thenReturn(null);
  }
 */

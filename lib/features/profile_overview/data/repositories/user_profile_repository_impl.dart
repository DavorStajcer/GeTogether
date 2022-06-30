import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_together_app/core/error/success.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/network.dart/network_info.dart';
import 'package:get_together_app/features/authentication/data/models/user_data_model.dart';
import 'package:get_together_app/features/authentication/domain/entities/user_data.dart';
import 'package:get_together_app/features/profile_overview/domain/repositories/user_profile_repository.dart';

const String userProfileKey = "userProfileData";

class UserProfileRepositoryImpl extends UserProfileRepository {
  final NetworkInfo networkInfo;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  UserProfileRepositoryImpl(
      {required this.networkInfo,
      FirebaseFirestore? firebaseFirestore,
      FirebaseAuth? firebaseAuth,
      FirebaseStorage? firebaseStorage})
      : firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  @override
  Future<Either<Failure, UserDataPublic>> getUserProfileData(
    String? userId,
  ) async {
    final bool isConnected = await networkInfo.isConnected;
    if (!isConnected) return Left(NetworkFailure());
    try {
      final currentUserId = userId ?? firebaseAuth.currentUser!.uid;
      print(
          "GETTING DATA FROM FKING FIRESTORTE PIJHBFsnbi fWSAE'R3QŠ+BRFšiheAfršiAWEgAĐBSfrhgšiADĐŠS");
      return await _getDataFromFirestore(currentUserId);
    } catch (e) {
      print("ERROR -> $e");
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, UserDataPublic>> _getDataFromFirestore(
      String currentUserId) async {
    final response =
        await firebaseFirestore.collection("users").doc(currentUserId).get();
    print("RESPONSE -> $response");
    final Map<String, dynamic> userProfileJsonMap = response.data()!;
    return Right(UserModelPublic.fromJsonMap(userProfileJsonMap));
  }

  @override
  Future<Either<Failure, Success>> saveUserData(
    UserDataPublic userProfileData,
  ) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return Left(NetworkFailure());
    try {
      await firebaseFirestore
          .collection("users")
          .doc(firebaseAuth.currentUser!.uid)
          .set((userProfileData as UserModelPublic).toJsonMap());
      return Right(Success());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, String>> saveUserImageToFirebaseStorage(
    String image,
  ) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return Left(NetworkFailure());
    String fileName = firebaseAuth.currentUser!.uid;
    Reference reference =
        firebaseStorage.ref().child("userPictures").child(fileName);
    UploadTask uploadTask = reference
        .putFile(File(image)); //UploadTask implements Future indirectly

    return uploadTask.then<Either<Failure, String>>((value) async {
      final String imageUrl = await value.ref.getDownloadURL();
      return Right(imageUrl);
    }, onError: (error) {
      return Left(ServerFailure());
    });
  }
}

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_together_app/core/error/exceptions.dart';
import 'package:get_together_app/features/authentication/data/models/user_data_model.dart';
import 'package:get_together_app/core/util/exception_mapper.dart';

import '../../../../core/error/success.dart';
import '../../../../core/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/network.dart/network_info.dart';
import '../../domain/repository/user_auth_repository.dart';
import '../../presentation/models/auth_param.dart';

class UserAuthRepositoryImpl extends UserAuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firebaseFirestore;
  final NetworkInfo networkInfo;

  UserAuthRepositoryImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseStorage? firebaseStorage,
    FirebaseFirestore? firebaseFirestore,
    required this.networkInfo,
  })  : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  @override
  Stream<User?> listenToAuthStream() {
    return firebaseAuth.authStateChanges();
  }

  @override
  Future<Either<Failure, Success>> logIn(LogInParameters parameters) async {
    if (await networkInfo.isConnected) {
      try {
        await firebaseAuth.signInWithEmailAndPassword(
          email: parameters.email,
          password: parameters.password,
        );

        return Right(Success());
      } on FirebaseAuthException catch (e) {
        print(e.message);
        return Left(
          AuthenticationFailure(
            message: ExceptionMapper.mapAuthExceptionCodeToMessage(e.code),
          ),
        );
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, Success>> signUp(SignUpParameters parameters) async {
    if (await networkInfo.isConnected) {
      try {
        await firebaseAuth.createUserWithEmailAndPassword(
          email: parameters.email,
          password: parameters.password,
        );
        await _saveUserInfo(parameters);
        return Right(Success());
      } on FirebaseAuthException catch (e) {
        return Left(
          AuthenticationFailure(
            message: ExceptionMapper.mapAuthExceptionCodeToMessage(e.code),
          ),
        );
      }
    } else
      return Left(NetworkFailure());
  }

  Future<void> _saveUserInfo(SignUpParameters signUpParameters) async {
    final imageUrl =
        await _saveUserImageToFirebaseStorage(signUpParameters.image);

    final UserDataModel userPublic = UserModelPublic(
        userId: firebaseAuth.currentUser!.uid,
        username: signUpParameters.username,
        imageUrl: imageUrl);

    final UserDataModel userPrivate = UserModelPrivate(
      email: signUpParameters.email,
      password: signUpParameters.password,
    );

    firebaseFirestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .set(
          userPublic.toJsonMap(),
        );

    firebaseFirestore
        .collection("users_private")
        .doc(firebaseAuth.currentUser!.uid)
        .set(
          userPrivate.toJsonMap(),
        );
  }

  Future<String> _saveUserImageToFirebaseStorage(File image) async {
    String fileName = firebaseAuth.currentUser!.uid;
    Reference reference =
        firebaseStorage.ref().child("userPictures").child(fileName);
    UploadTask uploadTask =
        reference.putFile(image); //UploadTask implements Future indirectly

    return uploadTask.then<String>((value) async {
      return await value.ref.getDownloadURL();
    }, onError: (error) {
      throw ServerException();
    });
  }

  @override
  Future<Either<Failure, Success>> signOut() async {
    if (await networkInfo.isConnected) {
      try {
        await firebaseAuth.signOut();

        return Right(Success());
      } on FirebaseAuthException catch (e) {
        return Left(
          AuthenticationFailure(
            message: ExceptionMapper.mapAuthExceptionCodeToMessage(e.code),
          ),
        );
      }
    } else
      return Left(NetworkFailure());
  }
}

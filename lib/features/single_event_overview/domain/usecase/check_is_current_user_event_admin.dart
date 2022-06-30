import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:get_together_app/core/usecases/usecase.dart';

class CheckIsCurrentUserEventAdmin extends Usecase<bool, String> {
  final FirebaseAuth firebaseAuth;
  CheckIsCurrentUserEventAdmin({FirebaseAuth? firebaseAuth})
      : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
  @override
  Future<Either<Failure, bool>> call(String eventAdminId) async {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) return Left(ServerFailure());
    if (currentUser.uid != eventAdminId) return Right(false);
    return Right(true);
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/success.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/user_auth_repository.dart';

class SignUserOut extends Usecase<Success, NoParameters> {
  final UserAuthRepository userAuthRepository;

  SignUserOut(this.userAuthRepository);

  @override
  Future<Either<Failure, Success>> call(NoParameters parameters) async {
    return await userAuthRepository.signOut();
  }
}

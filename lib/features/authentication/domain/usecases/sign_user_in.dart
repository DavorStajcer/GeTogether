import '../../../../core/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/success.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/user_auth_repository.dart';
import '../../presentation/models/auth_param.dart';

class SignUserIn extends Usecase<Success, SignUpParameters> {
  final UserAuthRepository /*!*/ userAuthRepository;

  SignUserIn(this.userAuthRepository);

  @override
  Future<Either<Failure, Success>> call(SignUpParameters parameters) async {
    return await userAuthRepository.signUp(parameters);
  }
}

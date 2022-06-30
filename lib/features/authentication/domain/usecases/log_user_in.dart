import '../../../../core/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/success.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/user_auth_repository.dart';
import '../../presentation/models/auth_param.dart';

class LogUserIn extends Usecase<Success, LogInParameters> {
  final UserAuthRepository userAuthRepository;

  LogUserIn(this.userAuthRepository);

  @override
  Future<Either<Failure, Success>> call(LogInParameters parameters) async {
    return await userAuthRepository.logIn(parameters);
  }
}

import '../../../../core/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../repository/user_auth_repository.dart';
import '../../presentation/bloc/auth_check_bloc/authentication_check_bloc.dart';

class ListenToAuthStateChanges {
  final UserAuthRepository userRepository;

  ListenToAuthStateChanges(this.userRepository);

  void call(AuthenticationCheckBloc authenticationCheckBloc) {
    userRepository.listenToAuthStream().listen((user) {
      authenticationCheckBloc.add(AuthStateChanged(Right(user)));
    }, onError: (e) {
      authenticationCheckBloc.add(AuthStateChanged(
          Left(ServerFailure(message: "Cannot proceed with authentication"))));
    });
  }
}

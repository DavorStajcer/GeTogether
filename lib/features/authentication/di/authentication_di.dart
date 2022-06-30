import 'package:get_it/get_it.dart';
import '../../../core/network.dart/network_info.dart';
import '../domain/repository/user_auth_repository.dart';
import '../domain/usecases/listen_to_auth_state_changes.dart';
import '../domain/usecases/log_user_in.dart';
import '../domain/usecases/sign_user_in.dart';
import '../domain/usecases/sign_user_out.dart';
import '../presentation/bloc/auth_bloc/auth_bloc.dart';
import '../presentation/bloc/auth_check_bloc/authentication_check_bloc.dart';
import 'package:connectivity/connectivity.dart';
import '../presentation/bloc/form_bloc/form_bloc.dart';

import '../data/repositories/user_auth_repository_impl.dart';

final getIt = GetIt.instance;

init() {
  print("registered objects");

  //Auth
  getIt.registerFactory<AuthBloc>(() =>
      AuthBloc(logUserIn: getIt(), signUserIn: getIt(), signUserOut: getIt()));
  getIt.registerLazySingleton(() => LogUserIn(getIt()));
  getIt.registerLazySingleton(() => SignUserIn(getIt()));
  getIt.registerLazySingleton(() => SignUserOut(getIt()));

  //AuthCheck
  getIt.registerFactory<AuthenticationCheckBloc>(() => AuthenticationCheckBloc(
      networkInfo: getIt<NetworkInfo>(),
      listenToAuthStateChanges: getIt<ListenToAuthStateChanges>()));

  getIt.registerLazySingleton<ListenToAuthStateChanges>(
      () => ListenToAuthStateChanges(getIt()));

  //AuthForm
  getIt.registerFactory(() => FormBloc());

  //Common

  getIt.registerLazySingleton<UserAuthRepository>(
      () => UserAuthRepositoryImpl(networkInfo: getIt()));

  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
}

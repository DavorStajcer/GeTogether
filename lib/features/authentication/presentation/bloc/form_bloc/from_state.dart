import 'dart:io';

import 'package:equatable/equatable.dart';
import '../../models/email.dart';
import '../../models/password.dart';
import '../../models/username.dart';

abstract class AuthFormState extends Equatable {
  final Email email;
  final Password password;

  AuthFormState({required this.email, required this.password});

  AuthFormState copyWith();

  @override
  List<Object?> get props => [email, password];
}

abstract class ValidForm {}

class LogInForm extends AuthFormState {
  LogInForm({
    Email? email,
    Password? password,
  }) : super(
          email: email ?? Email(),
          password: password ?? Password(),
        );

  LogInForm copyWith({
    Email? email,
    Password? password,
  }) =>
      LogInForm(
        email: email ?? this.email,
        password: password ?? this.password,
      );

  bool isValid() {
    return email.isValid && password.isValid;
  }
}

class ValidLoginForm extends LogInForm implements ValidForm {
  ValidLoginForm({Email? email, Password? password})
      : super(
          email: email,
          password: password,
        );
  ValidLoginForm.fromInvalidForm(LogInForm form)
      : super(
          email: form.email,
          password: form.password,
        );

  ValidLoginForm copyWith({
    Email? email,
    Password? password,
  }) =>
      ValidLoginForm(
        email: email ?? this.email,
        password: password ?? this.password,
      );
}

class SignUpForm extends AuthFormState {
  final Username username;

  final ConfirmPassword confirmPassword;
  final File? image;

  SignUpForm({
    Email? email,
    Username? username,
    Password? password,
    ConfirmPassword? confirmPassword,
    File? image,
  })  : username = username ?? Username(),
        confirmPassword = confirmPassword ?? ConfirmPassword(),
        image = image ?? null,
        super(
          password: password ?? Password(),
          email: email ?? Email(),
        );

  SignUpForm copyWith({
    Email? email,
    Username? username,
    Password? password,
    ConfirmPassword? confirmPassword,
    File? image,
  }) =>
      SignUpForm(
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        image: image ?? this.image,
      );

  bool isValid() {
    return confirmPassword.isValid && username.isValid && image != null;
  }

  @override
  List<Object?> get props => [
        email,
        password,
        username,
        confirmPassword,
        image != null ? image!.path : null
      ];
}

class ValidSignUpForm extends SignUpForm implements ValidForm {
  ValidSignUpForm({
    required Email email,
    required Password password,
    required Username username,
    required ConfirmPassword confirmPassword,
    required File image,
  }) : super(
          email: email,
          password: password,
          username: username,
          confirmPassword: confirmPassword,
          image: image,
        );

  ValidSignUpForm.fromInvalidForm(SignUpForm form)
      : super(
          email: form.email,
          password: form.password,
          username: form.username,
          confirmPassword: form.confirmPassword,
          image: form.image,
        );

  ValidSignUpForm copyWith({
    Email? email,
    Password? password,
    Username? username,
    ConfirmPassword? confirmPassword,
    File? image,
  }) =>
      ValidSignUpForm(
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        image: image ?? this.image!,
      );
}

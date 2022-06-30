import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'form_event.dart';
import 'from_state.dart';
import '../../models/email.dart';
import '../../models/password.dart';
import '../../models/username.dart';
import 'package:image_picker/image_picker.dart';

class FormBloc extends Bloc<FormEvent, AuthFormState> {
  final ImagePicker imagePicker;
  FormBloc({ImagePicker? imagePicker})
      : imagePicker = imagePicker ?? ImagePicker(),
        super(LogInForm());

  @override
  Stream<AuthFormState> mapEventToState(FormEvent event) async* {
    if (state is LogInForm) {
      yield* _mapEventToLogInState(event);
    } else {
      yield* _mapEventToSignUpState(event);
    }
  }

  Stream<AuthFormState> _mapEventToLogInState(FormEvent event) async* {
    if (event is FormTypeChanged)
      yield SignUpForm(email: state.email, password: state.password);
    else {
      late LogInForm newLogInForm;

      if (event is EmailChanged) {
        newLogInForm =
            (state as LogInForm).copyWith(email: Email(value: event.newValue));
      }
      if (event is PasswordChanged) {
        newLogInForm = (state as LogInForm).copyWith(
          password: Password(value: event.newValue),
        );
      }

      yield newLogInForm.isValid()
          ? ValidLoginForm.fromInvalidForm(newLogInForm)
          : newLogInForm;
    }
  }

  Stream<AuthFormState> _mapEventToSignUpState(FormEvent event) async* {
    if (event is FormTypeChanged)
      yield LogInForm(email: state.email, password: state.password);
    else {
      late SignUpForm signUpForm;
      if (event is EmailChanged) {
        signUpForm =
            (state as SignUpForm).copyWith(email: Email(value: event.newValue));
      }

      if (event is PasswordChanged) {
        signUpForm = (state as SignUpForm).copyWith(
            password: Password(value: event.newValue),
            confirmPassword: ConfirmPassword(
              value: (state as SignUpForm).confirmPassword.value,
              otherPassword: event.newValue,
            ));
      }
      if (event is UsernameChanged) {
        signUpForm = (state as SignUpForm)
            .copyWith(username: Username(value: event.newValue));
      }
      if (event is ConfirmPasswordChanged) {
        signUpForm = (state as SignUpForm).copyWith(
            confirmPassword: ConfirmPassword(
                value: event.newValue, otherPassword: state.password.value));
      }
      if (event is PickImageEvent) {
        final PickedFile? image = await imagePicker.getImage(
            source: event.imageSource, imageQuality: 70);
        signUpForm = (state as SignUpForm).copyWith(
          image: image == null ? null : File(image.path),
        );
      }

      yield signUpForm.isValid()
          ? ValidSignUpForm.fromInvalidForm(signUpForm)
          : signUpForm;
    }
  }
}

//@dart=2.6

import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/features/authentication/presentation/bloc/form_bloc/form_bloc.dart';
import 'package:get_together_app/features/authentication/presentation/bloc/form_bloc/form_event.dart';
import 'package:get_together_app/features/authentication/presentation/bloc/form_bloc/from_state.dart';
import 'package:get_together_app/features/authentication/presentation/models/email.dart';
import 'package:get_together_app/features/authentication/presentation/models/password.dart';
import 'package:get_together_app/features/authentication/presentation/models/username.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';

class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  MockImagePicker mockImagePicker;
  FormBloc formBloc;

  String tValidEmail;
  String tPassword;
  String tUsername;
  String tConfirmPassword;

  String tFilePath;

  setUp(() {
    print("SETUP IS RUNINIGNSIGNSIGNSDIGWSI");
    mockImagePicker = MockImagePicker();
    formBloc = FormBloc(imagePicker: mockImagePicker);

    tValidEmail = "daca@gmail.com";
    tPassword = "testPassword";
    tUsername = "testUsername";
    tConfirmPassword = "testConfirmPassword";
    tFilePath = "testPath";
  });

  test("initial state shoudl be LogInForm", () {
    expect(formBloc.state, isA<LogInForm>());
  });

  blocTest("should change to good form type when event is FormTypeChanged",
      build: () => formBloc,
      act: (dynamic bloc) {
        bloc.add(FormTypeChanged());
        bloc.add(FormTypeChanged());
      },
      expect: () => [
            isA<SignUpForm>(),
            isA<LogInForm>(),
          ]);
  blocTest("return good ValidLoginForm after all is good",
      build: () => formBloc,
      act: (dynamic bloc) {
        bloc.add(EmailChanged(tValidEmail));
        bloc.add(PasswordChanged(tPassword));
      },
      expect: () => [
            LogInForm(email: Email(value: tValidEmail)),
            ValidLoginForm(
                email: Email(value: tValidEmail),
                password: Password(value: tPassword)),
          ]);

  blocTest("return good ValidSingUpForm after all is good",
      build: () {
        print(formBloc.imagePicker.runtimeType);
        when(mockImagePicker.getImage(
                source: ImageSource.camera, imageQuality: 70))
            .thenAnswer(
                (realInvocation) => Future.value(PickedFile(tFilePath)));
        when(mockImagePicker.getImage(
                source: ImageSource.gallery, imageQuality: 70))
            .thenAnswer((realInvocation) =>
                Future.value(PickedFile(tFilePath + "daca")));

        return formBloc;
      },
      act: (dynamic bloc) {
        bloc.add(EmailChanged(tValidEmail));
        bloc.add(PasswordChanged(tPassword));
        bloc.add(FormTypeChanged());
        bloc.add(UsernameChanged(tUsername));
        bloc.add(PickImageEvent(ImageSource.camera));
        bloc.add(PickImageEvent(ImageSource.gallery));
        bloc.add(ConfirmPasswordChanged(tConfirmPassword));
        bloc.add(ConfirmPasswordChanged(tPassword));
        bloc.add(ConfirmPasswordChanged(tPassword));
      },
      expect: () => [
            LogInForm(
              email: Email(value: tValidEmail), //good email entered
            ),
            ValidLoginForm(
              email: Email(value: tValidEmail),
              password: Password(value: tPassword), //good password entered
            ),
            SignUpForm(
              email: Email(value: tValidEmail),
              password: Password(value: tPassword), //changed to sign up
            ),
            SignUpForm(
              email: Email(value: tValidEmail),
              password: Password(value: tPassword),
              username: Username(value: tUsername), // added good username
            ),
            SignUpForm(
              email: Email(value: tValidEmail),
              password: Password(value: tPassword), //added image from camera
              username: Username(value: tUsername),
              image: File(tFilePath),
            ),
            SignUpForm(
              email: Email(value: tValidEmail),
              password: Password(value: tPassword), //added image from gallery
              username: Username(value: tUsername),
              image: File(tFilePath + "daca"),
            ),
            SignUpForm(
              email: Email(value: tValidEmail),
              username: Username(value: tUsername),
              password:
                  Password(value: tPassword), //added wrong confirm password
              image: File(tFilePath + "daca"),
              confirmPassword: ConfirmPassword(value: tConfirmPassword),
            ),
            ValidSignUpForm(
              email: Email(value: tValidEmail),
              password: Password(
                  value: tPassword), //added good confirm password, all is good
              username: Username(value: tUsername),
              image: File(tFilePath + "daca"),
              confirmPassword: ConfirmPassword(value: tPassword),
            ),
          ]);
}

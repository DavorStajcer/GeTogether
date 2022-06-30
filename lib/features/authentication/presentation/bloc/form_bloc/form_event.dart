import 'package:image_picker/image_picker.dart';

abstract class FormEvent {}

class EmailChanged extends FormEvent {
  final String newValue;

  EmailChanged(this.newValue);
}

class UsernameChanged extends FormEvent {
  final String newValue;

  UsernameChanged(this.newValue);
}

class PasswordChanged extends FormEvent {
  final String newValue;

  PasswordChanged(this.newValue);
}

class ConfirmPasswordChanged extends FormEvent {
  final String newValue;

  ConfirmPasswordChanged(this.newValue);
}

class PickImageEvent extends FormEvent {
  final ImageSource imageSource;
  PickImageEvent(this.imageSource);
}

class FormTypeChanged extends FormEvent {}

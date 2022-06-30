import 'package:equatable/equatable.dart';

class Password extends Equatable {
  final String? value;
  bool get isValid =>
      value != null &&
      errorMessage ==
          null; //Kada je polje prazno (tek kad se otvori screen) ne zelim da korisniku izadje sve crveno, stoga nmg provjerit jer valid samo sa errorMessage != null

  final String? errorMessage;

  Password({String? value, String? errorMessage})
      : value = value,
        errorMessage = errorMessage ?? _mapValueToErrorMessage(value);

  @override
  List<Object?> get props => [value];
}

class ConfirmPassword extends Password {
  ConfirmPassword({String? value, String? otherPassword})
      : super(
            value: value,
            errorMessage: _mapValueToErrorMessageForConfirmPassword(
                value, otherPassword));
}

String? _mapValueToErrorMessage(String? value) {
  if (value == null) return null;

  String? errorMessage;
  if (value.isEmpty) errorMessage = "Password can't be empty.";
  if (value.length < 4)
    errorMessage = "Password must be at least 4 characters.";
  return errorMessage;
}

String? _mapValueToErrorMessageForConfirmPassword(
    String? value, String? otherValue) {
  if (value == null || otherValue == null) return null;

  String? errorMessage;
  if (value.isEmpty) errorMessage = "Password can't be empty.";
  if (value.length < 4)
    errorMessage = "Password must be at least 4 characters.";
  if (value != otherValue) errorMessage = "Passwords must mach.";
  return errorMessage;
}

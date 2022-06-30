import 'package:equatable/equatable.dart';

class Email extends Equatable {
  final String? value;
  bool get isValid =>
      value != null &&
      errorMessage ==
          null; //Kada je polje prazno (tek kad se otvori screen) ne zelim da korisniku izadje sve crveno, stoga nmg provjerit jer valid samo sa errorMessage != null

  final String? errorMessage;

  Email({String? value})
      : value = value,
        errorMessage = _mapValueToErrorMessage(value);

  @override
  List<Object?> get props => [value];
}

String? _mapValueToErrorMessage(String? value) {
  if (value == null) return null;
  final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$', //valid characters for email
  );
  String? errorMessage;
  if (value.isEmpty) errorMessage = "Email cant be empty.";
  if (!_emailRegex.hasMatch(value) || !value.contains("."))
    errorMessage = "Email must be a valid email.";
  print(errorMessage);
  return errorMessage;
}

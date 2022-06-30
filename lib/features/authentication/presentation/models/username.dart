import 'package:equatable/equatable.dart';

class Username extends Equatable {
  final String? value;

  bool get isValid {
    return value != null &&
        errorMessage ==
            null; //Kada je polje prazno (tek kad se otvori screen) ne zelim da korisniku izadje sve crveno, stoga nmg provjerit jer valid samo sa errorMessage != null
  }

  final String? errorMessage;

  Username({String? value})
      : value = value,
        errorMessage = _mapValueToErrorMessage(value);

  @override
  List<Object?> get props => [value];
}

String? _mapValueToErrorMessage(String? value) {
  if (value == null) return null;
  String? errorMessage;
  if (value.isEmpty) errorMessage = "Username cant be empty.";
  if (value.length < 4)
    errorMessage = "Username must be at least 4 characters long.";
  return errorMessage;
}

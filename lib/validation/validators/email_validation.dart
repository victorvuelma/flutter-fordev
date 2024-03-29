import 'package:equatable/equatable.dart';

import '../../presentation/protocols/validation.dart';

import '../protocols/protocols.dart';

class EmailValidation extends Equatable implements FieldValidation {
  @override
  final String field;

  final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  List get props => [field];

  EmailValidation(this.field);

  @override
  ValidationError? validate(Map<String, String?>? input) {
    final value = input?[field];

    final isValid =
        input?[field]?.isNotEmpty != true || emailRegex.hasMatch(value!);

    return isValid ? null : ValidationError.invalidField;
  }
}

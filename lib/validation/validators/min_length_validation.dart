import 'package:equatable/equatable.dart';

import '../../presentation/protocols/validation.dart';

import '../protocols/protocols.dart';

class MinLengthValidation extends Equatable implements FieldValidation {
  @override
  final String field;

  final int length;

  MinLengthValidation({
    required this.field,
    required this.length,
  });

  @override
  List get props => [field, length];

  @override
  ValidationError? validate(Map<String, String?>? input) {
    final value = input?[field];

    return value != null && value.length >= length
        ? null
        : ValidationError.invalidField;
  }
}

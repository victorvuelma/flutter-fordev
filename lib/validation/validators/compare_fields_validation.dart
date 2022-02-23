import 'package:equatable/equatable.dart';

import '../../presentation/protocols/validation.dart';

import '../protocols/protocols.dart';

class CompareFieldsValidation extends Equatable implements FieldValidation {
  @override
  final String field;

  final String fieldToCompare;

  CompareFieldsValidation({
    required this.field,
    required this.fieldToCompare,
  });

  @override
  List get props => [field, fieldToCompare];

  @override
  ValidationError? validate(Map<String, String?>? input) {
    final value = input?[field];
    final valueToCompare = input?[fieldToCompare];

    return value == valueToCompare ? null : ValidationError.invalidField;
  }
}

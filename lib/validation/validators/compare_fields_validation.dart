import 'package:equatable/equatable.dart';

import '../../presentation/protocols/validation.dart';

import '../protocols/protocols.dart';

class CompareFieldsValidation extends Equatable implements FieldValidation {
  @override
  final String field;

  final String valueToCompare;

  CompareFieldsValidation({
    required this.field,
    required this.valueToCompare,
  });

  @override
  List get props => [field, valueToCompare];

  @override
  ValidationError? validate(String? value) {
    return value == valueToCompare ? null : ValidationError.invalidField;
  }
}

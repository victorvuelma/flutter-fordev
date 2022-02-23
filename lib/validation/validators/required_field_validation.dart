import 'package:equatable/equatable.dart';

import '../../presentation/protocols/validation.dart';

import '../protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  @override
  final String field;

  @override
  List get props => [field];

  RequiredFieldValidation(this.field);

  @override
  ValidationError? validate(Map<String, String?>? input) {
    final value = input?[field];

    return value?.isNotEmpty == true ? null : ValidationError.requiredField;
  }
}

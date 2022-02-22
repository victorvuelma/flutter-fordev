import 'package:test/test.dart';

import 'package:fordev/presentation/protocols/protocols.dart';

import 'package:fordev/validation/protocols/protocols.dart';

class MinLengthValidation implements FieldValidation {
  @override
  final String field;

  final int length;

  MinLengthValidation({
    required this.field,
    required this.length,
  });

  @override
  ValidationError? validate(String? value) {
    return ValidationError.invalidField;
  }
}

void main() {
  test('Should error if value is empty', () {
    final sut = MinLengthValidation(field: 'any_field', length: 5);
    final error = sut.validate('');

    expect(error, ValidationError.invalidField);
  });

  test('Should error if value is null', () {
    final sut = MinLengthValidation(field: 'any_field', length: 5);
    final error = sut.validate(null);

    expect(error, ValidationError.invalidField);
  });
}

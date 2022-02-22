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
  late MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'any_field', length: 5);
  });

  test('Should error if value is empty', () {
    expect(sut.validate(''), ValidationError.invalidField);
  });

  test('Should error if value is null', () {
    expect(sut.validate(null), ValidationError.invalidField);
  });
}

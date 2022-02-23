import 'package:test/test.dart';

import 'package:fordev/presentation/protocols/protocols.dart';

import 'package:fordev/validation/validators/validators.dart';

void main() {
  late CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(
      field: 'any_field',
      fieldToCompare: 'other_field',
    );
  });

  test('Should return null on invalid cases', () {
    expect(
      sut.validate({'any_field': 'any_value'}),
      null,
    );
    expect(
      sut.validate({'other_field': 'any_value'}),
      null,
    );
    expect(sut.validate({}), null);
  });

  test('Should return error if values are not equals', () {
    final formData = {
      'any_field': 'any_value',
      'other_field': 'wrong_value',
    };

    expect(sut.validate(formData), ValidationError.invalidField);
  });

  test('Should return null if values are equals', () {
    final formData = {
      'any_field': 'any_value',
      'other_field': 'any_value',
    };

    expect(sut.validate(formData), null);
  });
}

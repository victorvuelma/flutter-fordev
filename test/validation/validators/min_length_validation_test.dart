import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:fordev/presentation/protocols/protocols.dart';

import 'package:fordev/validation/validators/validators.dart';

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

  test('Should error if value is less than min length', () {
    expect(
      sut.validate(faker.randomGenerator.string(4, min: 1)),
      ValidationError.invalidField,
    );
  });

  test('Should null if value is equal than min length', () {
    expect(
      sut.validate(faker.randomGenerator.string(5, min: 5)),
      null,
    );
  });

  test('Should null if value is bigger than min length', () {
    expect(
      sut.validate(faker.randomGenerator.string(10, min: 6)),
      null,
    );
  });
}

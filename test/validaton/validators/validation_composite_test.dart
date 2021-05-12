import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/validation/protocols/protocols.dart';
import 'package:fordev/validation/validators/validators.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  late FieldValidationSpy validation1;
  late FieldValidationSpy validation2;
  late FieldValidationSpy validation3;

  late ValidationComposite sut;

  void mockValidation1(String? error) {
    when(() => validation1.validate(any())).thenReturn(error);
  }

  void mockValidation2(String? error) {
    when(() => validation2.validate(any())).thenReturn(error);
  }

  void mockValidation3(String? error) {
    when(() => validation3.validate(any())).thenReturn(error);
  }

  setUp(() {
    validation1 = FieldValidationSpy();
    when(() => validation1.field).thenReturn('any_field');
    mockValidation1(null);

    validation2 = FieldValidationSpy();
    when(() => validation2.field).thenReturn('any_field');
    mockValidation2(null);

    validation3 = FieldValidationSpy();
    when(() => validation3.field).thenReturn('other_field');
    mockValidation3(null);

    sut = ValidationComposite([validation1, validation2, validation3]);
  });

  test('Should return null if all validations returns null or empty', () {
    mockValidation2('');

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, null);
  });

  test('Should return the first error', () {
    mockValidation1('first error');
    mockValidation2('second error');
    mockValidation3('other error');

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, 'first error');
  });

  test('Should return the first error of the correct field', () {
    mockValidation1('first error');
    mockValidation3('other error');

    final error = sut.validate(field: 'other_field', value: 'any_value');

    expect(error, 'other error');
  });
}

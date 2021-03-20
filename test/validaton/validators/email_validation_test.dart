import 'package:test/test.dart';

import 'package:fordev/validation/validators/validators.dart';

void main() {
  late EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('Should return null if email is empty', () {
    final error = sut.validate('');

    expect(error, null);
  });

  test('Should return null if email is null', () {
    final error = sut.validate(null);

    expect(error, null);
  });

  test('Should return null if email is valid', () {
    final error = sut.validate('vuelma@farmarcas.com.br');

    expect(error, null);
  });

  test('Should return error if email is invalid', () {
    final error = sut.validate('vuelmanãoémail');

    expect(error, 'Email inválido');
  });
}

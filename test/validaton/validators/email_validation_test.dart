import 'package:test/test.dart';

import 'package:fordev/validation/protocols/protocols.dart';

class EmailValidation implements FieldValidation {
  final String field;

  final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  EmailValidation(this.field);

  String validate(String value) {
    final isValid = value?.isNotEmpty != true || emailRegex.hasMatch(value);

    return isValid ? null : 'Email inválido';
  }
}

void main() {
  EmailValidation sut;

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

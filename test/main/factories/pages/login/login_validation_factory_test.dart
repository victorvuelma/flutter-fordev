import 'package:test/test.dart';

import 'package:fordev/main/factories/factories.dart';

import 'package:fordev/validation/validators/validators.dart';

void main() {
  test('Should return the correct validations', () {
    final validations = makeLoginFieldValidations();

    expect(validations, [
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
      MinLengthValidation(field: 'password', length: 3),
    ]);
  });
}

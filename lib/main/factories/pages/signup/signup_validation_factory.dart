import '../../../../presentation/protocols/protocols.dart';

import '../../../../validation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';

import '../../../builders/builders.dart';

Validation makeSignUpValidation() {
  return ValidationComposite(makeSignUpFieldValidations());
}

List<FieldValidation> makeSignUpFieldValidations() {
  return [
    ...ValidationBuilder.field('name').required().minLength(3).build(),
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().minLength(3).build(),
    ...ValidationBuilder.field('passwordConfirmation')
        .required()
        .minLength(3)
        .sameAs('password')
        .build(),
  ];
}

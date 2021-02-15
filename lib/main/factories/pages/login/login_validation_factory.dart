import '../../../../presentation/protocols/protocols.dart';

import '../../../../validation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';

import '../../../builders/builders.dart';

Validation makeLoginValidation() {
  return ValidationComposite(makeLoginFieldValidations());
}

List<FieldValidation> makeLoginFieldValidations() {
  return [
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().build()
  ];
}

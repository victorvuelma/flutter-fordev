import '../../../../presentation/protocols/protocols.dart';

import '../../../../validation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';

Validation makeLoginValidation() {
  return ValidationComposite(makeLoginFieldValidations());
}

List<FieldValidation> makeLoginFieldValidations() {
  return [
    RequiredFieldValidation('email'),
    EmailValidation('email'),
    RequiredFieldValidation('password'),
  ];
}

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  ValidationError? validate({
    required String field,
    required Map<String, String?>? input,
  }) {
    for (final validation in validations.where((v) => v.field == field)) {
      final error = validation.validate(input);

      if (error != null) {
        return error;
      }
    }

    return null;
  }
}

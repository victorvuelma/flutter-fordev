abstract class Validation {
  ValidationError? validate({
    required String field,
    required Map<String, String?>? input,
  });
}

enum ValidationError {
  requiredField,
  invalidField,
}

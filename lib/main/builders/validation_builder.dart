import '../../validation/protocols/protocols.dart';
import '../../validation/validators/validators.dart';

class ValidationBuilder {
  // static late ValidationBuilder _instance;

  final String _fieldName;
  final List<FieldValidation> _validations = [];

  ValidationBuilder._(this._fieldName);

  static ValidationBuilder field(String fieldName) {
    final instance = ValidationBuilder._(fieldName);

    return instance;
  }

  ValidationBuilder required() {
    _validations.add(RequiredFieldValidation(_fieldName));

    return this;
  }

  ValidationBuilder email() {
    _validations.add(EmailValidation(_fieldName));

    return this;
  }

  ValidationBuilder minLength(int lenght) {
    _validations.add(MinLengthValidation(field: _fieldName, length: lenght));

    return this;
  }

  List<FieldValidation> build() => _validations;
}

import 'package:get/get.dart';

import '../../ui/helpers/helpers.dart';

import '../protocols/protocols.dart';

class GetxSignUpPresenter extends GetxController {
  final Validation validation;

  final _emailError = Rxn<UiError>();
  final _nameError = Rxn<UiError>();

  final _isFormValid = false.obs;

  @override
  Stream<UiError?> get emailErrorStream => _emailError.stream;
  @override
  Stream<UiError?> get nameErrorStream => _nameError.stream;

  @override
  Stream<bool?> get isFormValidStream => _isFormValid.stream;

  GetxSignUpPresenter({
    required this.validation,
  });

  @override
  void validateEmail(String email) {
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  @override
  void validateName(String name) {
    _nameError.value = _validateField(field: 'name', value: name);
    _validateForm();
  }

  UiError? _validateField({
    required String field,
    required String value,
  }) {
    final error = validation.validate(field: field, value: value);

    if (error == null) {
      return null;
    }

    switch (error) {
      case ValidationError.invalidField:
        return UiError.invalidField;
      case ValidationError.requiredField:
        return UiError.requiredField;
      default:
        return UiError.unexpected;
    }
  }

  void _validateForm() {
    _isFormValid.value = false;
  }
}

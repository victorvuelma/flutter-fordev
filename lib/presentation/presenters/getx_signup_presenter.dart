import 'package:get/get.dart';

import '../../ui/helpers/helpers.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../protocols/protocols.dart';

class GetxSignUpPresenter extends GetxController {
  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  final _emailError = Rxn<UiError>();
  final _nameError = Rxn<UiError>();
  final _passwordError = Rxn<UiError>();
  final _passwordConfirmationError = Rxn<UiError>();

  final _mainError = Rxn<UiError>();

  final _isFormValid = false.obs;
  final _isLoading = false.obs;

  String? _email;
  String? _name;
  String? _password;
  String? _passwordConfirmation;

  @override
  Stream<UiError?> get emailErrorStream => _emailError.stream;
  @override
  Stream<UiError?> get nameErrorStream => _nameError.stream;
  @override
  Stream<UiError?> get passwordErrorStream => _passwordError.stream;
  @override
  Stream<UiError?> get passwordConfirmationErrorStream =>
      _passwordConfirmationError.stream;
  Stream<UiError?> get mainErrorStream => _mainError.stream;

  @override
  Stream<bool?> get isFormValidStream => _isFormValid.stream;
  @override
  Stream<bool?> get isLoadingStream => _isLoading.stream;

  GetxSignUpPresenter({
    required this.validation,
    required this.addAccount,
    required this.saveCurrentAccount,
  });

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  @override
  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField(field: 'name', value: name);
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: 'password', value: password);
    _validateForm();
  }

  @override
  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value = _validateField(
      field: 'passwordConfirmation',
      value: passwordConfirmation,
    );
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
    _isFormValid.value = _email != null &&
        _name != null &&
        _password != null &&
        _passwordConfirmation != null &&
        _emailError.value == null &&
        _nameError.value == null &&
        _passwordError.value == null &&
        _passwordConfirmationError.value == null;
  }

  @override
  Future<void> signUp() async {
    try {
      _isLoading.value = true;

      final account = await addAccount.add(AddAccountParams(
        name: _name!,
        email: _email!,
        password: _password!,
        passwordConfirmation: _passwordConfirmation!,
      ));
      await saveCurrentAccount.save(account);
    } on DomainError catch (error) {
      switch (error) {
        default:
          _mainError.value = UiError.unexpected;
          break;
      }
      _isLoading.value = false;
    }
  }
}

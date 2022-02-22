import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

import '../protocols/protocols.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  String? _email;
  String? _password;

  final _emailError = Rxn<UiError>();
  final _passwordError = Rxn<UiError>();
  final _mainError = Rxn<UiError>();
  final _navigateTo = RxnString();

  final _isFormValid = false.obs;
  final _isLoading = false.obs;

  @override
  Stream<UiError?> get emailErrorStream => _emailError.stream;
  @override
  Stream<UiError?> get passwordErrorStream => _passwordError.stream;
  @override
  Stream<UiError?> get mainErrorStream => _mainError.stream;
  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;

  @override
  Stream<bool?> get isFormValidStream => _isFormValid.stream;
  @override
  Stream<bool?> get isLoadingStream => _isLoading.stream;

  GetxLoginPresenter({
    required this.validation,
    required this.authentication,
    required this.saveCurrentAccount,
  });

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: 'password', value: password);
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
        _password != null &&
        _emailError.value == null &&
        _passwordError.value == null;
  }

  @override
  Future<void> auth() async {
    try {
      _mainError.value = null;
      _isLoading.value = true;

      final account = await authentication.auth(AuthenticationParams(
        email: _email!,
        secret: _password!,
      ));

      await saveCurrentAccount.save(account);

      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      _isLoading.value = false;

      switch (error) {
        case DomainError.invalidCredentials:
          _mainError.value = UiError.invalidCredentials;
          break;
        default:
          _mainError.value = UiError.unexpected;
          break;
      }
    }
  }

  @override
  void goToSignUp() {
    _navigateTo.value = '/signup';
  }
}

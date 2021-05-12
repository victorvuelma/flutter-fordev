import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../../ui/pages/login/login_presenter.dart';

import '../protocols/protocols.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  String? _email;
  String? _password;

  final _emailError = RxnString();
  final _passwordError = RxnString();
  final _mainError = RxnString();
  final _navigateTo = RxnString();

  final _isFormValid = false.obs;
  final _isLoading = false.obs;

  @override
  Stream<String?> get emailErrorStream => _emailError.stream;
  @override
  Stream<String?> get passwordErrorStream => _passwordError.stream;
  @override
  Stream<String?> get mainErrorStream => _mainError.stream;
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
    _emailError.value = validation.validate(field: 'email', value: email);
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value =
        validation.validate(field: 'password', value: password);
    _validateForm();
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
      _isLoading.value = true;

      final account = await authentication.auth(AuthenticationParams(
        email: _email!,
        secret: _password!,
      ));

      await saveCurrentAccount.save(account);

      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      _mainError.value = error.description;
      _isLoading.value = false;
    }
  }
}

import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:meta/meta.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../../ui/pages/login/login_presenter.dart';

import '../protocols/protocols.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;

  String _email;
  String _password;

  var emailError = RxString();
  var passwordError = RxString();
  var mainError = RxString();

  var isFormValid = false.obs;
  var isLoading = false.obs;

  GetxLoginPresenter({
    @required this.validation,
    @required this.authentication,
  });

  void validateEmail(String email) {
    _email = email;
    emailError.value = validation.validate(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    passwordError.value =
        validation.validate(field: 'password', value: password);
    _validateForm();
  }

  void _validateForm() {
    isFormValid.value = _email != null &&
        _password != null &&
        emailError.value == null &&
        passwordError.value == null;
  }

  Future<void> auth() async {
    isLoading.value = true;

    try {
      await authentication.auth(AuthenticationParams(
        email: _email,
        secret: _password,
      ));
    } on DomainError catch (error) {
      mainError.value = error.description;
    }

    isLoading.value = false;
  }
}

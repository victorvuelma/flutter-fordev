import '../../helpers/errors/errors.dart';

abstract class SignUpPresenter {
  Stream<UiError?> get nameErrorStream;
  Stream<UiError?> get emailErrorStream;
  Stream<UiError?> get passwordErrorStream;
  Stream<UiError?> get passwordConfirmationErrorStream;

  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;

  void validateName(String name);

  void validateEmail(String email);

  void validatePassword(String password);

  void validatePasswordConfirmation(String passwordConfirmation);

  Future<void> signUp();
}

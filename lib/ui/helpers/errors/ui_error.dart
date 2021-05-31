import '../i18n/i18n.dart';

enum UiError {
  requiredField,
  invalidField,
  unexpected,
  invalidCredentials,
}

extension UiErrorExt on UiError {
  String get description {
    switch (this) {
      case UiError.requiredField:
        return R.strings.msgRequiredField;
      case UiError.invalidField:
        return R.strings.msgInvalidField;
      case UiError.invalidCredentials:
        return R.strings.msgInvalidCredentials;
      default:
        return R.strings.msgUnexpectedError;
    }
  }
}

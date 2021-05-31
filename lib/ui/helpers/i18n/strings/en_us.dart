import './translations.dart';

class EnUs implements Translations {
  @override
  String get msgRequiredField => 'Required field';
  @override
  String get msgInvalidField => 'Invalid field';
  @override
  String get msgInvalidCredentials => 'Invalid credentials.';
  @override
  String get msgUnexpectedError =>
      'Something wrong has happed. Please try again soon';

  @override
  String get msgWait => 'Please wait...';

  @override
  String get addAccount => 'Create account';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign In';
}

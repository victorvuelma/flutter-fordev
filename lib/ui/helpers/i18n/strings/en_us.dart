import './translations.dart';

class EnUs implements Translations {
  String get msgRequiredField => 'Required field';
  String get msgInvalidField => 'Invalid field';
  String get msgInvalidCredentials => 'Invalid credentials.';
  String get msgUnexpectedError =>
      'Something wrong has happed. Please try again soon';

  String get msgWait => 'Please wait...';

  String get addAccount => 'Create account';
  String get signIn => 'Sign In';

  String get email => 'Email';
  String get name => 'Name';

  String get password => 'Password';
  String get confirmPassword => 'Confirm password';
}

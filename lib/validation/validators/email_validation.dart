import '../protocols/protocols.dart';

class EmailValidation implements FieldValidation {
  final String field;

  final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  EmailValidation(this.field);

  String validate(String value) {
    final isValid = value?.isNotEmpty != true || emailRegex.hasMatch(value);

    return isValid ? null : 'Email inválido';
  }
}

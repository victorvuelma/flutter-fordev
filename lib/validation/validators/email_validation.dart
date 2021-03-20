import 'package:equatable/equatable.dart';

import '../protocols/protocols.dart';

class EmailValidation extends Equatable implements FieldValidation {
  final String field;

  final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  List get props => [this.field];

  EmailValidation(this.field);

  String? validate(String? value) {
    final isValid = value?.isNotEmpty != true || emailRegex.hasMatch(value!);

    return isValid ? null : 'Email inválido';
  }
}

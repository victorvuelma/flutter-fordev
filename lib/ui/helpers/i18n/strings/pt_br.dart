import './translations.dart';

class PtBr implements Translations {
  String get msgRequiredField => 'Campo obrigatório';
  String get msgInvalidField => 'Campo inválido';
  String get msgInvalidCredentials => 'Credenciais inválidas.';
  String get msgEmailInUse => 'O email já está em uso.';
  String get msgUnexpectedError =>
      'Algo errado aconteceu. Tente novamente em breve.';

  String get msgWait => 'Aguarde...';

  String get addAccount => 'Criar conta';
  String get signIn => 'Entrar';

  String get email => 'Email';
  String get name => 'Nome';
  String get password => 'Senha';
  String get confirmPassword => 'Confirmar senha';
}

import './translations.dart';

class PtBr implements Translations {
  @override
  String get msgRequiredField => 'Campo obrigatório';
  @override
  String get msgInvalidField => 'Campo inválido';
  @override
  String get msgInvalidCredentials => 'Credenciais inválidas.';
  @override
  String get msgUnexpectedError =>
      'Algo errado aconteceu. Tente novamente em breve.';

  @override
  String get msgWait => 'Aguarde...';

  @override
  String get addAccount => 'Criar conta';

  @override
  String get email => 'Email';
  @override
  String get password => 'Senha';
  @override
  String get signIn => 'Entrar';
}

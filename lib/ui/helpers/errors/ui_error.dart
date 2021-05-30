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
        return 'Campo obrigatório.';
      case UiError.invalidField:
        return 'Campo inválido.';
      case UiError.invalidCredentials:
        return 'Credenciais inválidas.';
      default:
        return 'Algo errado aconteceu. Tente novamente em breve.';
    }
  }
}

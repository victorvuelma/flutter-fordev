import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/presentation/protocols/protocols.dart';

import 'package:fordev/ui/helpers/errors/ui_error.dart';

class AddAccountParamsFake extends Fake implements AddAccountParams {}

class AccountEntityFake extends Fake implements AccountEntity {}

class ValidationSpy extends Mock implements Validation {}

class AddAccountSpy extends Mock implements AddAccount {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  late GetxSignUpPresenter sut;
  late ValidationSpy validation;
  late AddAccountSpy addAccount;
  late SaveCurrentAccountSpy saveCurrentAccount;
  late String email;
  late String name;
  late String password;
  late String passwordConfirmation;
  late String token;

  When mockValidationCall(String? field) => when(() => validation.validate(
      field: field ?? any(named: 'field'), input: any(named: 'input')));

  void mockValidation({
    String? field,
    ValidationError? value,
  }) {
    mockValidationCall(field).thenReturn(value);
  }

  When mockAddAccountCall() => when(() => addAccount.add(any()));

  void mockAddAccount() {
    mockAddAccountCall().thenAnswer((_) async => AccountEntity(token));
  }

  void mockAddAccountError(DomainError error) {
    mockAddAccountCall().thenThrow(error);
  }

  When mockSaveCurrentAccountCall() =>
      when(() => saveCurrentAccount.save(any()));

  void mockSaveCurrentAccount() {
    mockSaveCurrentAccountCall().thenAnswer((_) => Future<void>.value());
  }

  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
  }

  setUpAll(() {
    registerFallbackValue(AddAccountParamsFake());
    registerFallbackValue(AccountEntityFake());
  });

  setUp(() {
    validation = ValidationSpy();
    addAccount = AddAccountSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxSignUpPresenter(
      validation: validation,
      addAccount: addAccount,
      saveCurrentAccount: saveCurrentAccount,
    );
    email = faker.internet.email();
    name = faker.person.name();
    password = faker.internet.password();
    passwordConfirmation = faker.internet.password();
    token = faker.guid.guid();

    mockValidation();
    mockAddAccount();
    mockSaveCurrentAccount();
  });

  test('Should call Validation with correct email', () {
    final formData = {
      'name': null,
      'email': email,
      'password': null,
      'passwordConfirmation': null,
    };

    sut.validateEmail(email);

    verify(
      () => validation.validate(field: 'email', input: formData),
    ).called(1);
  });

  test('Should emit invalidField error if email is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit requiredField error if email is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct name', () {
    final formData = {
      'name': name,
      'email': null,
      'password': null,
      'passwordConfirmation': null,
    };

    sut.validateName(name);

    verify(
      () => validation.validate(field: 'name', input: formData),
    ).called(1);
  });

  test('Should emit invalidField error if name is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.nameErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit requiredField error if name is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.nameErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit null if validation succeeds', () {
    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should call Validation with correct password', () {
    final formData = {
      'name': null,
      'email': null,
      'password': password,
      'passwordConfirmation': null,
    };

    sut.validatePassword(password);

    verify(
      () => validation.validate(field: 'password', input: formData),
    ).called(1);
  });

  test('Should emit invalidField error if password is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit requiredField error if password is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if validation succeeds', () {
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should call Validation with correct passwordConfirmation', () {
    final formData = {
      'name': null,
      'email': null,
      'password': null,
      'passwordConfirmation': passwordConfirmation,
    };

    sut.validatePasswordConfirmation(passwordConfirmation);

    verify(
      () => validation.validate(field: 'passwordConfirmation', input: formData),
    ).called(1);
  });

  test('Should emit invalidField error if passwordConfirmation is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.passwordConfirmationErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should emit requiredField error if passwordConfirmation is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.passwordConfirmationErrorStream
        .listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should emit null if validation succeeds', () {
    sut.passwordConfirmationErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should emit form valid if validation succeed', () async {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.passwordConfirmationErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    // ignore: unawaited_futures
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateName(name);
    await Future.delayed(Duration.zero);
    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validatePasswordConfirmation(passwordConfirmation);
    await Future.delayed(Duration.zero);
  });

  test('Should call AddAccount with correct values', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    await sut.signUp();

    verify(() => addAccount.add(
          AddAccountParams(
            email: email,
            name: name,
            password: password,
            passwordConfirmation: passwordConfirmation,
          ),
        )).called(1);
  });

  test('Should call SaveCurrentAccount with correct value', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    await sut.signUp();

    verify(() => saveCurrentAccount.save(AccountEntity(token))).called(1);
  });

  test('Should emit UnexpectedError if SaveCurrentAccount fails', () async {
    mockSaveCurrentAccountError();

    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    // ignore: unawaited_futures
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    // ignore: unawaited_futures
    expectLater(sut.mainErrorStream, emitsInOrder([null, UiError.unexpected]));

    await sut.signUp();
  });

  test('Should emit correct events on AddAccount success', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    // ignore: unawaited_futures
    expectLater(sut.isLoadingStream, emits(true));

    await sut.signUp();
  });

  test('Should emit correct events on EmailInUseError', () async {
    mockAddAccountError(DomainError.emailInUse);

    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    // ignore: unawaited_futures
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    // ignore: unawaited_futures
    expectLater(sut.mainErrorStream, emitsInOrder([null, UiError.emailInUse]));

    await sut.signUp();
  });

  test('Should emit correct events on UnexpectedError', () async {
    mockAddAccountError(DomainError.unexpected);

    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    // ignore: unawaited_futures
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    // ignore: unawaited_futures
    expectLater(sut.mainErrorStream, emitsInOrder([null, UiError.unexpected]));

    await sut.signUp();
  });

  test('Should change page on success', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.signUp();
  });

  test('Should go to LoginPage on link touch', () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    sut.goToLogin();
  });
}

import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {}

void main() {
  late SignUpPresenter presenter;
  late StreamController<UiError?> nameErrorController;
  late StreamController<UiError?> emailErrorController;
  late StreamController<UiError?> passwordErrorController;
  late StreamController<UiError?> passwordConfirmationErrorController;
  late StreamController<UiError?> mainErrorController;

  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;
  late StreamController<String?> navigateToController;

  void initStreams() {
    nameErrorController = StreamController<UiError?>();
    emailErrorController = StreamController<UiError?>();
    passwordErrorController = StreamController<UiError?>();
    passwordConfirmationErrorController = StreamController<UiError?>();
    mainErrorController = StreamController<UiError?>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
    navigateToController = StreamController<String?>();
  }

  void mockStreams() {
    when(() => presenter.nameErrorStream)
        .thenAnswer((_) => nameErrorController.stream);
    when(() => presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(() => presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(() => presenter.passwordConfirmationErrorStream)
        .thenAnswer((_) => passwordConfirmationErrorController.stream);
    when(() => presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(() => presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
  }

  void closeStreams() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
    mainErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    navigateToController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();
    when(() => presenter.signUp()).thenAnswer((_) => Future<void>.value());

    initStreams();
    mockStreams();

    final signUpPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(name: '/signup', page: () => SignUpPage(presenter)),
        GetPage(
            name: '/any_route', page: () => Scaffold(body: Text('fake page')))
      ],
    );
    await tester.pumpWidget(signUpPage);
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets('Should load with correct initial state', (
    WidgetTester tester,
  ) async {
    await loadPage(tester);

    final nameTextChildren = find.descendant(
        of: find.bySemanticsLabel('Nome'), matching: find.byType(Text));
    expect(
      nameTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text',
    );

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(
      emailTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text',
    );

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(
      passwordTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text',
    );

    final passwordConfirmationTextChildren = find.descendant(
        of: find.bySemanticsLabel('Confirmar senha'),
        matching: find.byType(Text));
    expect(
      passwordConfirmationTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text',
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should call validate with correct values', (
    WidgetTester tester,
  ) async {
    await loadPage(tester);

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    verify(() => presenter.validateName(name));

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(() => presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(() => presenter.validatePassword(password));

    await tester.enterText(find.bySemanticsLabel('Confirmar senha'), password);
    verify(() => presenter.validatePasswordConfirmation(password));
  });

  testWidgets('Should present email error', (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(UiError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido'), findsOneWidget);

    emailErrorController.add(UiError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);

    emailErrorController.add(null);
    await tester.pump();

    expect(
      find.descendant(
          of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('Should present name error', (WidgetTester tester) async {
    await loadPage(tester);

    nameErrorController.add(UiError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido'), findsOneWidget);

    nameErrorController.add(UiError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);

    nameErrorController.add(null);
    await tester.pump();

    expect(
      find.descendant(
          of: find.bySemanticsLabel('Nome'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('Should present password error', (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add(UiError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido'), findsOneWidget);

    passwordErrorController.add(UiError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);

    passwordErrorController.add(null);
    await tester.pump();

    expect(
      find.descendant(
          of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('Should present password confirmation error',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordConfirmationErrorController.add(UiError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido'), findsOneWidget);

    passwordConfirmationErrorController.add(UiError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);

    passwordConfirmationErrorController.add(null);
    await tester.pump();

    expect(
      find.descendant(
          of: find.bySemanticsLabel('Confirmar senha'),
          matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('Should enable button if form is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Should disable button if form is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(false);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('Should call signUp on form submit', (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    final button = find.byType(ElevatedButton);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenter.signUp()).called(1);
  });

  testWidgets('Should present loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should present error message if signUp fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    mainErrorController.add(UiError.emailInUse);
    await tester.pump();

    expect(find.text('O email já está em uso.'), findsOneWidget);
  });

  testWidgets('Should present error message if signUp throws',
      (WidgetTester tester) async {
    await loadPage(tester);

    mainErrorController.add(UiError.unexpected);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'),
        findsOneWidget);
  });

  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    await tester.pumpAndSettle();
    // refresh and wait animation

    expect(Get.currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();

    expect(Get.currentRoute, '/signup');

    navigateToController.add(null);
    await tester.pump();

    expect(Get.currentRoute, '/signup');
  });

  testWidgets('Should call goToLogin on link tap', (WidgetTester tester) async {
    await loadPage(tester);

    final button = find.text('Login');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenter.goToLogin()).called(1);
  });
}

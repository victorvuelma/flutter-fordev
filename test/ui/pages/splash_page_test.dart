import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';
import 'package:mocktail/mocktail.dart';

class SplashPage extends StatelessWidget {
  final SplashPresenter presenter;

  SplashPage({
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    presenter.loadCurrentAccount();

    return Scaffold(
      appBar: AppBar(
        title: Text('4dev'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

abstract class SplashPresenter {
  Future<void> loadCurrentAccount();
}

class SplashPresenterSpy extends Mock implements SplashPresenter {}

void main() {
  late SplashPresenter presenter;

  void mockLoadCurrentAccount() {
    when(() => presenter.loadCurrentAccount()).thenAnswer(
      (_) => Future<void>.value(),
    );
  }

  setUp(() {
    presenter = SplashPresenterSpy();

    mockLoadCurrentAccount();
  });

  Future<void> loadPage(WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashPage(presenter: presenter)),
      ],
    ));
  }

  testWidgets(
    'Should present spinner on page load',
    (WidgetTester tester) async {
      await loadPage(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'Should call loadCurrentAccount on page load',
    (WidgetTester tester) async {
      await loadPage(tester);

      verify(() => presenter.loadCurrentAccount()).called(1);
    },
  );
}

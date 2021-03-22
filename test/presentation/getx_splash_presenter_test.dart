import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:get/get.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/ui/pages/splash/splash_presenter.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  final _navigateTo = RxString();

  Stream<String?> get navigateToStream => _navigateTo.stream;

  GetxSplashPresenter({
    required this.loadCurrentAccount,
  });

  Future<void> loadAccount() async {
    await loadCurrentAccount.load();
  }
}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

class AccountEntityFake extends Fake implements AccountEntity {}

void main() {
  late LoadCurrentAccount loadCurrentAccount;
  late GetxSplashPresenter sut;

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);

    when(() => loadCurrentAccount.load()).thenAnswer(
      (_) => Future<AccountEntity>.value(AccountEntityFake()),
    );
  });

  test('Should call LoadCurrentAccount', () async {
    await sut.loadAccount();

    verify(() => loadCurrentAccount.load()).called(1);
  });
}

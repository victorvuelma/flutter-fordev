import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';

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
    final account = await loadCurrentAccount.load();

    _navigateTo.value = account == null ? '/login' : '/surveys';
  }
}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  late LoadCurrentAccount loadCurrentAccount;
  late GetxSplashPresenter sut;

  void mockLoadCurrentAccount({
    required AccountEntity? account,
  }) {
    when(() => loadCurrentAccount.load()).thenAnswer(
      (_) => Future<AccountEntity?>.value(account),
    );
  }

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);

    mockLoadCurrentAccount(account: AccountEntity(faker.guid.guid()));
  });

  test('Should call LoadCurrentAccount', () async {
    await sut.loadAccount();

    verify(() => loadCurrentAccount.load()).called(1);
  });

  test('Should go to surveys page on success', () async {
    sut.navigateToStream.listen(
      expectAsync1((page) => expect(page, '/surveys')),
    );

    await sut.loadAccount();
  });

  test('Should go to login page on null result', () async {
    mockLoadCurrentAccount(account: null);

    sut.navigateToStream.listen(
      expectAsync1((page) => expect(page, '/login')),
    );

    await sut.loadAccount();
  });
}

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usecases/usecases.dart';

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {
}

void main() {
  late AccountEntity account;
  late SaveSecureCacheStorageSpy saveSecureCacheStorage;
  late LocalSaveCurrentAccount sut;

  When mockSaveSecureCall() {
    return when(() => saveSecureCacheStorage.saveSecure(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ));
  }

  void mockSaveSecure() {
    mockSaveSecureCall().thenAnswer((_) => Future<void>.value());
  }

  void mockError() {
    mockSaveSecureCall().thenThrow(Exception());
  }

  setUp(() {
    saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    sut =
        LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(faker.guid.guid());

    mockSaveSecure();
  });

  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);

    verify(() => saveSecureCacheStorage.saveSecure(
          key: 'token',
          value: account.token,
        ));
  });

  test('Should throw UnexpectedError SaveSecureCacheStorage throws', () async {
    mockError();

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}

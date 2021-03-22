import 'package:faker/faker.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:fordev/infra/cache/cache.dart';

// Spy - Mock values and capture
// Stub - Mock values
// Mock - Capture values

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  late LocalStorageAdapter sut;
  late FlutterSecureStorageSpy secureStorage;
  late String key;
  late String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    key = faker.guid.guid();
    value = faker.lorem.word();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
  });

  group('saveSecure', () {
    When mockSaveSecureCall() => when(
          () => secureStorage.write(
              key: any(named: 'key'), value: any(named: 'value')),
        );

    void mockSaveSecure() {
      mockSaveSecureCall().thenAnswer((_) => Future<void>.value());
    }

    void mockSaveSecureError() {
      mockSaveSecureCall().thenThrow(Exception());
    }

    setUp(() {
      mockSaveSecure();
    });
    test('Should call save secure with correct values', () async {
      await sut.saveSecure(key: key, value: value);

      verify(() => secureStorage.write(key: key, value: value));
    });

    test('Should throw if save secure throws', () async {
      mockSaveSecureError();

      final future = sut.saveSecure(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('fetchSecure', () {
    When mockFetchSecureCall() => when(
          () => secureStorage.read(key: any(named: 'key')),
        );

    void mockFetchSecure() {
      mockFetchSecureCall().thenAnswer((_) async => value);
    }

    void mockFetchSecureError() {
      mockFetchSecureCall().thenThrow(Exception());
    }

    setUp(() {
      mockFetchSecure();
    });

    test('Should call fetch secure with correct value', () async {
      await sut.fetchSecure(key);

      verify(() => secureStorage.read(key: key));
    });

    test('Should return correct value on success', () async {
      final storageValue = await sut.fetchSecure(key);

      expect(storageValue, value);
    });

    test('Should throw if fetchSecure throws', () {
      mockFetchSecureError();

      final future = sut.fetchSecure(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
}

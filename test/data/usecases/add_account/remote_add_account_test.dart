import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAddAccount sut;
  late HttpClientSpy httpClient;
  late String url;
  late AddAccountParams params;

  Map mockValidData() => {
        'accessToken': faker.guid.guid(),
        'name': faker.person.name(),
      };

  When mockRequest() => when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'),
      ));

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();

    sut = RemoteAddAccount(httpClient: httpClient, url: url);

    mockHttpData(mockValidData());

    params = AddAccountParams(
      name: faker.person.name(),
      email: faker.internet.email(),
      password: faker.internet.password(),
      passwordConfirmation: faker.internet.password(),
    );
  });

  test('Should call HttpClient with correct values', () async {
    await sut.add(params);

    verify(
      () => httpClient.request(
        url: url,
        method: 'post',
        body: {
          'name': params.name,
          'email': params.email,
          'password': params.password,
          'passwordConfirmation': params.passwordConfirmation,
        },
      ),
    );
  });

  test('Should throw UnexpectedError if HttpClient Returns 400', () async {
    mockHttpError(HttpError.badRequest);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient Returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient Returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw EmailInUseError if HttpClient Returns 403', () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.emailInUse));
  });

  test('Should return an Account if HttpClient Returns 200', () async {
    final validData = mockValidData();
    mockHttpData(validData);

    final account = await sut.add(params);

    expect(account.token, validData['accessToken']);
  });

  test(
      'Should throw UnexpectedError if HttpClient Returns 200 with invalid data',
      () async {
    mockHttpData({'invalid_key': 'invalid_value'});

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}

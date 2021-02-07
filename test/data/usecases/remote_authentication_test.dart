import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';

// Test double
class HttpClientSpy extends Mock implements HttpClient {}

// triple A pattern
void main() {
  RemoteAuthentication sut;
  HttpClientSpy httpClient;
  String url;
  AuthenticationParams params;

  setUp(() {
    // 1 step - arrange
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    params = AuthenticationParams(
      email: faker.internet.email(),
      secret: faker.internet.password(),
    );

    // System under test
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('Should call HttpClient with correct values', () async {
    // 2 step - act (action)
    await sut.auth(params);

    // 3 step - asset
    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {
        'email': params.email,
        'password': params.secret,
      },
    ));
  });
  test('Should throw UnexpectedError if HttpClient Returns 400', () async {
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenThrow(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}

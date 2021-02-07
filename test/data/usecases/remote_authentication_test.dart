import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
// @required annotation
import 'package:meta/meta.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> auth() async {
    await httpClient.request(url: url, method: 'post');
  }
}

abstract class HttpClient {
  Future<void> request({
    @required String url,
    @required String method,
  });
}

// Test double
class HttpClientSpy extends Mock implements HttpClient {}

// triple A pattern
void main() {
  RemoteAuthentication sut;
  HttpClientSpy httpClient;
  String url;

  setUp(() {
    // 1 step - arrange
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();

    // System under test
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('Should call HttpClient with correct values', () async {
    // 2 step - act (action)
    await sut.auth();

    // 3 step - asset
    verify(httpClient.request(
      url: url,
      method: 'post',
    ));
  });
}

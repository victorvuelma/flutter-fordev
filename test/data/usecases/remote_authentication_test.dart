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
    await httpClient.request(url: url);
  }
}

abstract class HttpClient {
  Future<void> request({
    @required String url,
  });
}

// Test double
class HttpClientSpy extends Mock implements HttpClient {}

// triple A pattern
void main() {
  test('Should call HttpClient with correct URL', () async {
    // System under test

    // 1 step - arrange
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);

    // 2 step - act (action)
    await sut.auth();

    // 3 step - asset
    verify(httpClient.request(url: url));
  });
}

import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:fordev/data/http/http_client.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<Map> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
    final headers = {
      'accept': 'application/json',
      'content-type': 'application/json',
    };
    final jsonBody = body != null ? jsonEncode(body) : null;

    final response = await client.post(
      url,
      headers: headers,
      body: jsonBody,
    );

    return jsonDecode(response.body);
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  HttpAdapter sut;
  Client client;
  String url;

  setUp(() {
    client = ClientSpy();
    url = faker.internet.httpUrl();
    sut = HttpAdapter(client);
  });
  group('post', () {
    test('Should call post with correct values', () async {
      when(client.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer(
        (_) async => Response('{"res_key":"res_value"}', 200),
      );

      await sut.request(url: url, method: 'post', body: {
        'any_key': 'any_value',
      });

      verify(client.post(
        url,
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
        },
        body: '{"any_key":"any_value"}',
      ));
    });

    test('Should call post without body', () async {
      when(client.post(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => Response('{"res_key":"res_value"}', 200),
      );

      await sut.request(url: url, method: 'post');

      verify(client.post(
        any,
        headers: anyNamed('headers'),
      ));
    });

    test('Should return data if post returns 200', () async {
      when(client.post(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => Response('{"res_key":"res_value"}', 200),
      );

      final response = await sut.request(url: url, method: 'post');

      expect(
        response,
        {
          'res_key': 'res_value',
        },
      );
    });
  });
}

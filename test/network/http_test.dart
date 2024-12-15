import 'dart:convert';
import 'dart:io';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../test_container.dart';
import 'fake_http_client_factory.dart';

void main() {
  setUp(() {
    FakeClient.reset();
  });

  group('LichessClient', () {
    test('sends requests to lichess host', () async {
      final container = await makeContainer(
        overrides: [
          httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => FakeClient());
          }),
        ],
      );
      final client = container.read(lichessClientProvider);
      final response = await client.get(Uri(path: '/test'));
      expect(response.statusCode, 200);
      final requests = FakeClient.verifyRequests();
      expect(
        requests.first,
        isA<http.BaseRequest>()
            .having((r) => r.url.path, 'path', '/test')
            .having((r) => r.url.host, 'host', 'lichess.dev')
            .having((r) => r.url.scheme, 'scheme', 'https'),
      );
    });

    test('sets user agent (no session)', () async {
      final container = await makeContainer(
        overrides: [
          httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => FakeClient());
          }),
        ],
      );
      final client = container.read(lichessClientProvider);
      await client.get(Uri(path: '/test'));
      final requests = FakeClient.verifyRequests();
      expect(
        requests.first,
        isA<http.BaseRequest>().having(
          (r) => r.headers['User-Agent'],
          'User-Agent',
          'Lichess Mobile/0.0.0 as:anon sri:test-sri',
        ),
      );
    });

    test('sets user agent (with session)', () async {
      final container = await makeContainer(
        overrides: [
          httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => FakeClient());
          }),
        ],
        userSession: const AuthSessionState(
          token: 'test-token',
          user: LightUser(id: UserId('test-user-id'), name: 'test-username'),
        ),
      );
      final client = container.read(lichessClientProvider);
      await client.get(Uri(path: '/test'));
      final requests = FakeClient.verifyRequests();
      expect(
        requests.first,
        isA<http.BaseRequest>().having(
          (r) => r.headers['User-Agent'],
          'User-Agent',
          'Lichess Mobile/0.0.0 as:test-user-id sri:test-sri',
        ),
      );
    });

    test('read methods throw ServerException on status code >= 400', () async {
      final container = await makeContainer(
        overrides: [
          httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => FakeClient());
          }),
        ],
      );
      final client = container.read(lichessClientProvider);
      for (final method in [
        client.read,
        client.readBytes,
        (Uri url) => client.readJson(url, mapper: (json) => json),
        (Uri url) => client.readJsonList(url, mapper: (json) => json),
        (Uri url) => client.readNdJsonList(url, mapper: (json) => json),
        (Uri url) => client.readNdJsonStream(url, mapper: (json) => json),
      ]) {
        expect(
          () => method(Uri(path: '/will/return/500')),
          throwsA(isA<ServerException>().having((e) => e.statusCode, 'statusCode', 500)),
        );
        expect(
          () => method(Uri(path: '/will/return/503')),
          throwsA(isA<ServerException>().having((e) => e.statusCode, 'statusCode', 503)),
        );
        expect(
          () => method(Uri(path: '/will/return/400')),
          throwsA(isA<ServerException>().having((e) => e.statusCode, 'statusCode', 400)),
        );
        expect(
          () => method(Uri(path: '/will/return/404')),
          throwsA(isA<ServerException>().having((e) => e.statusCode, 'statusCode', 404)),
        );
        expect(
          () => method(Uri(path: '/will/return/401')),
          throwsA(isA<ServerException>().having((e) => e.statusCode, 'statusCode', 401)),
        );
        expect(
          () => method(Uri(path: '/will/return/403')),
          throwsA(isA<ServerException>().having((e) => e.statusCode, 'statusCode', 403)),
        );
      }
    });

    test('other methods do not throw on status code >= 400', () async {
      final container = await makeContainer(
        overrides: [
          httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => FakeClient());
          }),
        ],
      );
      final client = container.read(lichessClientProvider);
      for (final method in [client.get, client.post, client.put, client.patch, client.delete]) {
        expect(() => method(Uri(path: '/will/return/500')), returnsNormally);
        expect(() => method(Uri(path: '/will/return/503')), returnsNormally);
        expect(() => method(Uri(path: '/will/return/400')), returnsNormally);
        expect(() => method(Uri(path: '/will/return/404')), returnsNormally);
        expect(() => method(Uri(path: '/will/return/401')), returnsNormally);
        expect(() => method(Uri(path: '/will/return/403')), returnsNormally);
      }
    });

    test('socket and tls errors do not throw ClientException', () async {
      final container = await makeContainer(
        overrides: [
          httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => FakeClient());
          }),
        ],
      );
      final client = container.read(lichessClientProvider);
      expect(
        () => client.get(Uri(path: '/will/throw/socket/exception')),
        throwsA(isA<SocketException>().having((e) => e.message, 'message', 'no internet')),
      );
      expect(
        () => client.get(Uri(path: '/will/throw/tls/exception')),
        throwsA(isA<TlsException>().having((e) => e.message, 'message', 'tls error')),
      );
    });

    test('failed JSON parsing will throw ClientException', () async {
      final container = await makeContainer(
        overrides: [
          httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => FakeClient());
          }),
        ],
      );
      final client = container.read(lichessClientProvider);
      expect(
        () => client.readJson(
          Uri(path: '/will/return/204'),
          mapper: (json) {
            return json;
          },
        ),
        throwsA(
          isA<http.ClientException>().having(
            (e) => e.message,
            'message',
            'Could not read JSON object as Map<String, dynamic>: expected an object.',
          ),
        ),
      );
    });

    test('adds a signed bearer token when a session is available the request', () async {
      final container = await makeContainer(
        overrides: [
          httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => FakeClient());
          }),
        ],
        userSession: const AuthSessionState(
          token: 'test-token',
          user: LightUser(id: UserId('test-user-id'), name: 'test-username'),
        ),
      );

      final session = container.read(authSessionProvider);
      expect(session, isNotNull);

      final client = container.read(lichessClientProvider);
      await client.get(Uri(path: '/test'));

      final requests = FakeClient.verifyRequests();
      expect(requests.length, 1);
      expect(
        requests.first,
        isA<http.BaseRequest>().having(
          (r) => r.headers['Authorization'],
          'Authorization',
          'Bearer ${signBearerToken('test-token')}',
        ),
      );
    });

    test(
      'when receiving a 401, will test session token and delete session if not valid anymore',
      () async {
        int nbTokenTestRequests = 0;
        final container = await makeContainer(
          overrides: [
            httpClientFactoryProvider.overrideWith((ref) {
              return FakeHttpClientFactory(() => FakeClient());
            }),
            defaultClientProvider.overrideWith((ref) {
              return MockClient((request) async {
                if (request.url.path == '/api/token/test') {
                  nbTokenTestRequests++;
                  final token = request.body.split(',')[0];
                  final response = '{"$token": null}';
                  return http.Response(response, 200);
                }
                return http.Response('', 404);
              });
            }),
          ],
          userSession: const AuthSessionState(
            token: 'test-token',
            user: LightUser(id: UserId('test-user-id'), name: 'test-username'),
          ),
        );

        fakeAsync((async) {
          final session = container.read(authSessionProvider);
          expect(session, isNotNull);

          final client = container.read(lichessClientProvider);
          try {
            client.get(Uri(path: '/will/return/401'));
          } on ServerException catch (_) {}

          async.flushMicrotasks();

          final requests = FakeClient.verifyRequests();
          expect(requests.length, 1);
          expect(
            requests.first,
            isA<http.BaseRequest>().having(
              (r) => r.headers['Authorization'],
              'Authorization',
              'Bearer ${signBearerToken('test-token')}',
            ),
          );

          expect(nbTokenTestRequests, 1);

          expect(container.read(authSessionProvider), isNull);
        });
      },
    );

    test('when receiving a 401, will test session token and keep session if still valid', () async {
      int nbTokenTestRequests = 0;
      final container = await makeContainer(
        overrides: [
          httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => FakeClient());
          }),
          defaultClientProvider.overrideWith((ref) {
            return MockClient((request) async {
              if (request.url.path == '/api/token/test') {
                nbTokenTestRequests++;
                final token = request.body.split(',')[0];
                final response =
                    '{"$token": {"userId": "test-user-id","scope": "web:mobile", "expires":1760704968038}}';
                return http.Response(response, 200);
              }
              return http.Response('', 404);
            });
          }),
        ],
        userSession: const AuthSessionState(
          token: 'test-token',
          user: LightUser(id: UserId('test-user-id'), name: 'test-username'),
        ),
      );

      fakeAsync((async) {
        final session = container.read(authSessionProvider);
        expect(session, isNotNull);

        final client = container.read(lichessClientProvider);
        try {
          client.get(Uri(path: '/will/return/401'));
        } on ServerException catch (_) {}

        async.flushMicrotasks();

        final requests = FakeClient.verifyRequests();
        expect(requests.length, 1);
        expect(
          requests.first,
          isA<http.BaseRequest>().having(
            (r) => r.headers['Authorization'],
            'Authorization',
            'Bearer ${signBearerToken('test-token')}',
          ),
        );

        expect(nbTokenTestRequests, 1);

        expect(container.read(authSessionProvider), equals(session));
      });
    });
  });
}

class FakeClient extends http.BaseClient {
  static List<http.BaseRequest> _requests = [];

  static List<http.BaseRequest> verifyRequests() {
    final result = _requests;
    _requests = [];
    return result;
  }

  static void reset() {
    _requests = [];
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    _requests.add(request);

    return _responseBasedOnPath(request, request.finalize());
  }

  Future<http.StreamedResponse> _responseBasedOnPath(
    http.BaseRequest request,
    http.ByteStream bodyStream,
  ) async {
    switch (request.url.path) {
      case '/will/throw/socket/exception':
        throw const SocketException('no internet');
      case '/will/throw/tls/exception':
        throw const TlsException('tls error');
      case '/will/return/500':
        return http.StreamedResponse(_streamBody('500'), 500);
      case '/will/return/503':
        return http.StreamedResponse(_streamBody('503'), 503);
      case '/will/return/400':
        return http.StreamedResponse(_streamBody('400'), 400);
      case '/will/return/404':
        return http.StreamedResponse(_streamBody('404'), 404);
      case '/will/return/401':
        return http.StreamedResponse(_streamBody('401'), 401);
      case '/will/return/403':
        return http.StreamedResponse(_streamBody('403'), 403);
      case '/will/return/204':
        return http.StreamedResponse(_streamBody('204'), 204);
      case '/will/return/301':
        return http.StreamedResponse(_streamBody('301'), 301);
      default:
        return http.StreamedResponse(_streamBody('200'), 200);
    }
  }
}

Stream<List<int>> _streamBody(String body) => Stream.value(utf8.encode(body));

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
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

  group('shouldRetryOn429', () {
    http.Response response(int status, {String method = 'GET', String path = '/api/test'}) {
      return http.Response(
        '',
        status,
        request: http.Request(method, Uri.parse('https://lichess.org$path')),
      );
    }

    test('retries a generic 429', () {
      expect(shouldRetryOn429(response(429)), isTrue);
      expect(shouldRetryOn429(response(429, method: 'POST')), isTrue);
    });

    test('does not retry non-429 responses', () {
      expect(shouldRetryOn429(response(200)), isFalse);
      expect(shouldRetryOn429(response(503)), isFalse);
    });

    test('does not retry a puzzle solve submission (POST /api/puzzle/batch)', () {
      // solveBatch handles 429 with a back-off, so the retry only wastes a call
      expect(
        shouldRetryOn429(response(429, method: 'POST', path: '/api/puzzle/batch/mix')),
        isFalse,
      );
    });

    test('does not retry a puzzle batch download (GET /api/puzzle/batch)', () {
      // Batch downloads are issued once per angle, so retrying doubles a burst the server has just
      // refused.
      expect(
        shouldRetryOn429(response(429, method: 'GET', path: '/api/puzzle/batch/mix')),
        isFalse,
      );
      expect(
        shouldRetryOn429(response(429, method: 'GET', path: '/api/puzzle/batch/advancedPawn')),
        isFalse,
      );
    });
  });

  group('RateLimitLichessClient', () {
    /// Runs [nbRequests] concurrent requests to [path] and reports how many were ever in flight at
    /// the same time.
    Future<int> maxConcurrentRequests(String path, {int nbRequests = 5}) async {
      var inFlight = 0;
      var maxInFlight = 0;
      final mockClient = MockClient((request) async {
        inFlight++;
        maxInFlight = math.max(maxInFlight, inFlight);
        await Future<void>.delayed(const Duration(milliseconds: 10));
        inFlight--;
        return http.Response('{}', 200);
      });

      final container = await makeContainer(
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith((ref) {
            return RateLimitLichessClient(mockClient, ref);
          }),
        },
      );
      final client = container.read(lichessClientProvider);

      await Future.wait([for (var i = 0; i < nbRequests; i++) client.get(Uri(path: path))]);

      return maxInFlight;
    }

    test('sends puzzle batch requests one at a time', () async {
      // Regression test: the puzzle tab used to fire a batch request per saved angle at once, and
      // the server answered 429 to the lot. Whatever asks for them, they must go out serially.
      expect(await maxConcurrentRequests('/api/puzzle/batch/mix'), equals(1));
    });

    test('serializes puzzle batch requests across angles', () async {
      // The rate limit is per account, not per angle, so a queue per angle would not help.
      var inFlight = 0;
      var maxInFlight = 0;
      final mockClient = MockClient((request) async {
        inFlight++;
        maxInFlight = math.max(maxInFlight, inFlight);
        await Future<void>.delayed(const Duration(milliseconds: 10));
        inFlight--;
        return http.Response('{}', 200);
      });

      final container = await makeContainer(
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith((ref) {
            return RateLimitLichessClient(mockClient, ref);
          }),
        },
      );
      final client = container.read(lichessClientProvider);

      await Future.wait([
        for (final angle in ['mix', 'advancedPawn', 'pin', 'skewer', 'A00'])
          client.get(Uri(path: '/api/puzzle/batch/$angle')),
      ]);

      expect(maxInFlight, equals(1));
    });

    test('leaves the rest of the API alone', () async {
      // Only the puzzle batch endpoints are paced: everything else must still run in parallel.
      expect(await maxConcurrentRequests('/api/test'), equals(5));
    });

    test('sends puzzle batch requests in submission order', () async {
      final sent = <String>[];
      final mockClient = MockClient((request) async {
        sent.add(request.url.queryParameters['nb']!);
        // a later request answering faster must not let it be sent earlier
        await Future<void>.delayed(Duration(milliseconds: 30 - sent.length * 10));
        return http.Response('{}', 200);
      });

      final container = await makeContainer(
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith((ref) {
            return RateLimitLichessClient(mockClient, ref);
          }),
        },
      );
      final client = container.read(lichessClientProvider);

      await Future.wait([
        for (var i = 0; i < 3; i++)
          client.get(Uri(path: '/api/puzzle/batch/mix', queryParameters: {'nb': '$i'})),
      ]);

      expect(sent, equals(['0', '1', '2']));
    });
  });

  group('LichessClient', () {
    test('sends requests to lichess host when only path is provided', () async {
      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => FakeClient());
          }),
        },
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

    test('uses full URL as-is when host is provided', () async {
      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => FakeClient());
          }),
        },
      );
      final client = container.read(lichessClientProvider);
      final response = await client.get(Uri.https('explorer.lichess.org', '/test'));
      expect(response.statusCode, 200);
      final requests = FakeClient.verifyRequests();
      expect(
        requests.first,
        isA<http.BaseRequest>()
            .having((r) => r.url.path, 'path', '/test')
            .having((r) => r.url.host, 'host', 'explorer.lichess.org')
            .having((r) => r.url.scheme, 'scheme', 'https'),
      );
    });

    test('uses full URL as-is with query parameters when host is provided', () async {
      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => FakeClient());
          }),
        },
      );
      final client = container.read(lichessClientProvider);
      final response = await client.get(Uri.https('explorer.lichess.org', '/test', {'foo': 'bar'}));
      expect(response.statusCode, 200);
      final requests = FakeClient.verifyRequests();
      expect(
        requests.first,
        isA<http.BaseRequest>()
            .having((r) => r.url.host, 'host', 'explorer.lichess.org')
            .having((r) => r.url.queryParameters['foo'], 'query param', 'bar'),
      );
    });

    test('sets user agent (no authUser)', () async {
      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => FakeClient());
          }),
        },
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

    test('sets user agent (with authUser)', () async {
      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => FakeClient());
          }),
        },
        authUser: const AuthUser(
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
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => FakeClient());
          }),
        },
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
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => FakeClient());
          }),
        },
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
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => FakeClient());
          }),
        },
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
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => FakeClient());
          }),
        },
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

    test('adds a signed bearer token when a authUser is available the request', () async {
      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => FakeClient());
          }),
        },
        authUser: const AuthUser(
          token: 'test-token',
          user: LightUser(id: UserId('test-user-id'), name: 'test-username'),
        ),
      );

      final authUser = container.read(authControllerProvider);
      expect(authUser, isNotNull);

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
      'when receiving a 401, will test authUser token and delete authUser if not valid anymore',
      () async {
        int nbTokenTestRequests = 0;
        final container = await makeContainer(
          overrides: {
            httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
              return FakeHttpClientFactory(() => FakeClient());
            }),
            defaultClientProvider: defaultClientProvider.overrideWith((ref) {
              return DefaultClient(
                MockClient((request) async {
                  if (request.url.path == '/api/token/test') {
                    nbTokenTestRequests++;
                    final token = request.body.split(',')[0];
                    final response = '{"$token": null}';
                    return http.Response(response, 200);
                  }
                  return http.Response('', 404);
                }),
                userAgent: 'Lichess Mobile/0.0.0 as:test-user-id sri:test-sri',
              );
            }),
          },
          authUser: const AuthUser(
            token: 'test-token',
            user: LightUser(id: UserId('test-user-id'), name: 'test-username'),
          ),
        );

        fakeAsync((async) {
          final authUser = container.read(authControllerProvider);
          expect(authUser, isNotNull);

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

          expect(container.read(authControllerProvider), isNull);
        });
      },
    );

    test('when receiving a 401, will test authUser token and keep authUser if still valid', () async {
      int nbTokenTestRequests = 0;
      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => FakeClient());
          }),
          defaultClientProvider: defaultClientProvider.overrideWith((ref) {
            return DefaultClient(
              MockClient((request) async {
                if (request.url.path == '/api/token/test') {
                  nbTokenTestRequests++;
                  final token = request.body.split(',')[0];
                  final response =
                      '{"$token": {"userId": "test-user-id","scope": "web:mobile", "expires":1760704968038}}';
                  return http.Response(response, 200);
                }
                return http.Response('', 404);
              }),
              userAgent: 'Lichess Mobile/0.0.0 as:test-user-id sri:test-sri',
            );
          }),
        },
        authUser: const AuthUser(
          token: 'test-token',
          user: LightUser(id: UserId('test-user-id'), name: 'test-username'),
        ),
      );

      fakeAsync((async) {
        final authUser = container.read(authControllerProvider);
        expect(authUser, isNotNull);

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

        expect(container.read(authControllerProvider), equals(authUser));
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
        return http.StreamedResponse(_streamBody('''{"result": "ok"}'''), 200);
    }
  }
}

Stream<List<int>> _streamBody(String body) => Stream.value(utf8.encode(body));

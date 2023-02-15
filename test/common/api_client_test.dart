import 'dart:io';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:lichess_mobile/src/common/errors.dart';
import 'package:lichess_mobile/src/common/api_client.dart';

class MockLogger extends Mock implements Logger {}

class MockClient extends Mock implements http.Client {}

void main() {
  final mockLogger = MockLogger();

  setUpAll(() {
    registerFallbackValue(http.Request('GET', Uri.parse('http://api.test')));
  });

  group('ApiClient non stream', () {
    test('ValueResult responses are returned as success', () async {
      final apiClient = ApiClient(mockLogger, FakeClient());

      for (final method in [apiClient.get, apiClient.post, apiClient.delete]) {
        expect(
          await method.call(Uri.parse('http://api.test/will/return/200')),
          isA<ValueResult<http.Response>>(),
        );

        expect(
          await method.call(Uri.parse('http://api.test/will/return/301')),
          isA<ValueResult<http.Response>>(),
        );

        expect(
          await method.call(Uri.parse('http://api.test/will/return/204')),
          isA<ValueResult<http.Response>>(),
        );
      }
    });

    test('error responses are returned as error', () async {
      final apiClient = ApiClient(mockLogger, FakeClient());

      for (final method in [apiClient.get, apiClient.post, apiClient.delete]) {
        expect(
          await method
              .call(Uri.parse('http://api.test/will/return/401'))
              .then((r) => r.asError?.error),
          isA<UnauthorizedException>(),
        );

        expect(
          await method
              .call(Uri.parse('http://api.test/will/return/403'))
              .then((r) => r.asError?.error),
          isA<ForbiddenException>(),
        );

        expect(
          await method
              .call(Uri.parse('http://api.test/will/return/404'))
              .then((r) => r.asError?.error),
          isA<NotFoundException>(),
        );

        expect(
          await method
              .call(Uri.parse('http://api.test/will/return/500'))
              .then((r) => r.asError?.error),
          isA<ApiRequestException>(),
        );

        expect(
          await method
              .call(Uri.parse('http://api.test/will/return/503'))
              .then((r) => r.asError?.error),
          isA<ApiRequestException>(),
        );
      }
    });

    test('catches socket error', () async {
      final apiClient = ApiClient(mockLogger, FakeClient());
      for (final method in [apiClient.get, apiClient.post, apiClient.delete]) {
        final resp = await method
            .call(Uri.parse('http://api.test/will/throw/socket/exception'));
        expect(resp.asError?.error, isA<GenericIOException>());
      }
    });

    test('retry on error when asked', () async {
      final mockClient = MockClient();
      final apiClient = ApiClient(mockLogger, mockClient);

      int retries = 3;

      when(() => mockClient.send(any())).thenAnswer((_) async {
        retries--;
        return retries > 0
            ? throw const SocketException('oops')
            : http.StreamedResponse(_streamBody('ok'), 200);
      });

      final resp =
          await apiClient.get(Uri.parse('http://api.test/retry'), retry: true);

      verify(() => mockClient.send(any())).called(3);
      expect(resp, isA<ValueResult<http.Response>>());
    });
  });

  group('ApiClient stream', () {
    test('response is returned when ValueResult', () async {
      final apiClient = ApiClient(mockLogger, FakeClient());

      expect(
        await apiClient.stream(Uri.parse('http://api.test/will/return/200')),
        isA<http.StreamedResponse>(),
      );

      expect(
        await apiClient.stream(Uri.parse('http://api.test/will/return/301')),
        isA<http.StreamedResponse>(),
      );

      expect(
        await apiClient.stream(Uri.parse('http://api.test/will/return/204')),
        isA<http.StreamedResponse>(),
      );
    });

    test('throws on error', () {
      final apiClient = ApiClient(mockLogger, FakeClient());

      expect(
        () => apiClient.stream(Uri.parse('http://api.test/will/return/401')),
        throwsA(isA<UnauthorizedException>()),
      );

      expect(
        () => apiClient.stream(Uri.parse('http://api.test/will/return/403')),
        throwsA(isA<ForbiddenException>()),
      );

      expect(
        () => apiClient.stream(Uri.parse('http://api.test/will/return/404')),
        throwsA(isA<NotFoundException>()),
      );

      expect(
        () => apiClient.stream(Uri.parse('http://api.test/will/return/500')),
        throwsA(isA<ApiRequestException>()),
      );

      expect(
        () => apiClient.stream(Uri.parse('http://api.test/will/return/503')),
        throwsA(isA<ApiRequestException>()),
      );
    });

    test('socket error is a GenericIOException', () {
      final apiClient = ApiClient(mockLogger, FakeClient());

      expect(
        () => apiClient
            .stream(Uri.parse('http://api.test/will/throw/socket/exception')),
        throwsA(isA<GenericIOException>()),
      );
    });
  });
}

class FakeClient extends Fake implements http.Client {
  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    return _responseBasedOnPath(url.path) as http.Response;
  }

  @override
  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    return _responseBasedOnPath(url.path) as http.Response;
  }

  @override
  Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    return _responseBasedOnPath(url.path) as http.Response;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return _responseBasedOnPath(request.url.path, true)
        as http.StreamedResponse;
  }

  http.BaseResponse _responseBasedOnPath(String path, [bool stream = false]) {
    switch (path) {
      case '/will/throw/socket/exception':
        throw const SocketException('no internet');
      case '/will/return/500':
        return stream
            ? http.StreamedResponse(_streamBody('500'), 500)
            : http.Response('500', 500);
      case '/will/return/503':
        return stream
            ? http.StreamedResponse(_streamBody('503'), 503)
            : http.Response('503', 503);
      case '/will/return/400':
        return stream
            ? http.StreamedResponse(_streamBody('400'), 400)
            : http.Response('400', 400);
      case '/will/return/404':
        return stream
            ? http.StreamedResponse(_streamBody('404'), 404)
            : http.Response('404', 404);
      case '/will/return/401':
        return stream
            ? http.StreamedResponse(_streamBody('401'), 401)
            : http.Response('401', 401);
      case '/will/return/403':
        return stream
            ? http.StreamedResponse(_streamBody('403'), 403)
            : http.Response('403', 403);
      case '/will/return/204':
        return stream
            ? http.StreamedResponse(_streamBody('204'), 204)
            : http.Response('204', 204);
      case '/will/return/301':
        return stream
            ? http.StreamedResponse(_streamBody('301'), 301)
            : http.Response('301', 301);
      default:
        return stream
            ? http.StreamedResponse(_streamBody('200'), 200)
            : http.Response('200', 200);
    }
  }
}

Stream<List<int>> _streamBody(String body) => Stream.value(utf8.encode(body));

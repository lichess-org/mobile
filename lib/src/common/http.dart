import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import 'errors.dart';

const retries = [
  Duration(milliseconds: 200),
  Duration(milliseconds: 300),
  Duration(milliseconds: 500),
  Duration(milliseconds: 800),
  Duration(milliseconds: 1300),
];

/// Convenient client that captures and returns API errors.
class ApiClient {
  ApiClient(this._log, this._client)
      : _retryClient = RetryClient.withDelays(_client, retries,
            whenError: (_, __) => true) {
    _log.info('Creating new ApiClient.');
  }

  final Logger _log;
  final Client _client;
  final RetryClient _retryClient;

  TaskEither<IOError, Response> get(Uri url,
      {Map<String, String>? headers, bool retry = false}) {
    return TaskEither<IOError, Response>.tryCatch(
      () async => (retry ? _retryClient : _client).get(url, headers: headers),
      (error, trace) {
        _log.severe('Request error', error, trace);
        return GenericError(trace);
      },
    ).flatMap((resp) => _validateResponseStatus(url, resp));
  }

  TaskEither<IOError, Response> post(Uri url,
      {Map<String, String>? headers,
      Object? body,
      Encoding? encoding,
      bool retry = false}) {
    return TaskEither<IOError, Response>.tryCatch(
      () async => (retry ? _retryClient : _client)
          .post(url, headers: headers, body: body, encoding: encoding),
      (error, trace) {
        _log.severe('Request error', error, trace);
        return GenericError(trace);
      },
    ).flatMap((resp) => _validateResponseStatus(url, resp));
  }

  TaskEither<IOError, Response> delete(Uri url,
      {Map<String, String>? headers,
      Object? body,
      Encoding? encoding,
      bool retry = false}) {
    return TaskEither<IOError, Response>.tryCatch(
      () async => (retry ? _retryClient : _client)
          .delete(url, headers: headers, body: body, encoding: encoding),
      (error, trace) {
        _log.severe('Request error', error, trace);
        return GenericError(trace);
      },
    ).flatMap((resp) => _validateResponseStatus(url, resp));
  }

  Future<StreamedResponse> stream(Uri url) {
    return TaskEither<IOError, StreamedResponse>.tryCatch(
      () async => _client.send(Request('GET', url)),
      (error, trace) {
        _log.severe('Request error', error, trace);
        return GenericError(trace);
      },
    )
        .flatMap((resp) => _validateResponseStatus(url, resp))
        .run()
        .then((either) {
      return either.match((err) => throw err, (resp) => resp);
    });
  }

  TaskEither<IOError, T> _validateResponseStatus<T extends BaseResponse>(
      Uri url, T response) {
    if (response.statusCode >= 500) {
      _log.severe('$url responded with status ${response.statusCode}');
    } else if (response.statusCode >= 400) {
      _log.warning('$url responded with status ${response.statusCode}');
    }
    return response.statusCode < 400
        ? TaskEither.right(response)
        : response.statusCode == 404
            ? TaskEither.left(NotFoundError(StackTrace.current))
            : response.statusCode == 401
                ? TaskEither.left(UnauthorizedError(StackTrace.current))
                : response.statusCode == 403
                    ? TaskEither.left(ForbiddenError(StackTrace.current))
                    : TaskEither.left(ApiRequestError(StackTrace.current));
  }

  void close() {
    _log.info('Closing ApiClient.');
    _client.close();
    _retryClient.close();
  }
}

/// Http client that sets the Authorization header when a token has been stored.
class AuthClient extends BaseClient {
  final FlutterSecureStorage storage;
  final Client _inner;

  AuthClient(this.storage, this._inner);

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final token = await storage.read(key: kOAuthTokenStorageKey);
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    if (request.url.host == 'lichess.dev') {
      const creds = '$kLichessDevUser:$kLichessDevPassword';
      request.headers['authorization'] =
          'Basic ${base64.encode(utf8.encode(creds))}';
    }

    return _inner.send(request);
  }
}

final apiClientProvider = Provider<ApiClient>((ref) {
  const storage = FlutterSecureStorage();
  final authClient = AuthClient(storage, Client());
  final apiClient = ApiClient(Logger('ApiClient'), authClient);
  ref.onDispose(() {
    apiClient.close();
  });
  return apiClient;
});

import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants.dart';
import 'utils/errors.dart';

const retries = [
  Duration(milliseconds: 200),
  Duration(milliseconds: 300),
  Duration(milliseconds: 500),
];

/// Convenient client that captures and returns API errors.
class ApiClient {
  ApiClient(this._log, this._client)
      : _retryClient = RetryClient.withDelays(_client, retries,
            whenError: (_, __) => true);

  final Logger _log;
  final Client _client;
  final RetryClient _retryClient;

  TaskEither<IOError, Response> get(Uri url,
      {Map<String, String>? headers, bool retry = false}) {
    return TaskEither<IOError, Response>.tryCatch(
      () async => _sendRequest('GET', url, headers, retry),
      (error, trace) {
        _log.severe('Request error', error, trace);
        return ApiRequestError(trace);
      },
    ).flatMap((resp) => _validateResponseStatus(url, resp));
  }

  TaskEither<IOError, Response> post(Uri url,
      {Map<String, String>? headers,
      Object? body,
      Encoding? encoding,
      bool retry = false}) {
    return TaskEither<IOError, Response>.tryCatch(
      () async => _sendRequest('POST', url, headers, body, encoding, retry),
      (error, trace) {
        _log.severe('Request error', error, trace);
        return ApiRequestError(trace);
      },
    ).flatMap((resp) => _validateResponseStatus(url, resp));
  }

  TaskEither<IOError, Response> delete(Uri url,
      {Map<String, String>? headers,
      Object? body,
      Encoding? encoding,
      bool retry = false}) {
    return TaskEither<IOError, Response>.tryCatch(
      () async => _sendRequest('DELETE', url, headers, body, encoding, retry),
      (error, trace) {
        _log.severe('Request error', error, trace);
        return ApiRequestError(trace);
      },
    ).flatMap((resp) => _validateResponseStatus(url, resp));
  }

  /// Generic send request used to stream content.
  Future<StreamedResponse> send(BaseRequest request) {
    return _client.send(request);
  }

  Future<Response> _sendRequest(
      String method, Uri url, Map<String, String>? headers,
      [Object? body, Encoding? encoding, bool retry = false]) async {
    var request = Request(method, url);

    if (url.host == 'lichess.dev') {
      const creds = '$kLichessDevUser:$kLichessDevPassword';
      request.headers['authorization'] =
          'Basic ${base64.encode(utf8.encode(creds))}';
    }

    if (headers != null) request.headers.addAll(headers);
    if (encoding != null) request.encoding = encoding;
    if (body != null) {
      if (body is String) {
        request.body = body;
      } else if (body is List) {
        request.bodyBytes = body.cast<int>();
      } else if (body is Map) {
        request.bodyFields = body.cast<String, String>();
      } else {
        throw ArgumentError('Invalid request body "$body".');
      }
    }

    return Response.fromStream(
        await (retry ? _retryClient : _client).send(request));
  }

  TaskEither<IOError, T> _validateResponseStatus<T extends BaseResponse>(
      Uri url, T response) {
    if (response.statusCode >= 400) {
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

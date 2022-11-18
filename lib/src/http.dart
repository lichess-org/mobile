import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:http/http.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'constants.dart';
import 'utils/errors.dart';

/// Convenient client that captures and returns API errors.
class ApiClient {
  ApiClient(this._log, this._client);

  final Logger _log;
  final Client _client;

  TaskEither<IOError, Response> get(Uri url, {Map<String, String>? headers}) {
    return TaskEither<IOError, Response>.tryCatch(
      () async => _client.get(url, headers: headers),
      (error, trace) {
        _log.severe('Request error', error, trace);
        return ApiRequestError(trace);
      },
    ).flatMap(_validateResponseStatus);
  }

  TaskEither<IOError, Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return TaskEither<IOError, Response>.tryCatch(
      () async => _client.post(url, headers: headers, body: body, encoding: encoding),
      (error, trace) {
        _log.severe('Request error', error, trace);
        return ApiRequestError(trace);
      },
    ).flatMap(_validateResponseStatus);
  }

  TaskEither<IOError, Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return TaskEither<IOError, Response>.tryCatch(
      () async => _client.delete(url, headers: headers, body: body, encoding: encoding),
      (error, trace) {
        _log.severe('Request error', error, trace);
        return ApiRequestError(trace);
      },
    ).flatMap(_validateResponseStatus);
  }

  TaskEither<IOError, Response> _validateResponseStatus(Response response) {
    if (response.statusCode >= 400) {
      _log.warning('Request response status ${response.statusCode}; ${response.body}');
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
    _client.close();
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
    request.headers['Authorization'] = 'Bearer ${(token ?? '')}';
    return _inner.send(request);
  }
}

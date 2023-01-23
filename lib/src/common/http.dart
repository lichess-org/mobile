import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:http/http.dart';
import 'package:dart_result/dart_result.dart';
import 'package:http/retry.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import 'errors.dart';

const defaultRetries = [
  Duration(milliseconds: 200),
  Duration(milliseconds: 300),
  Duration(milliseconds: 500),
  Duration(milliseconds: 800),
  Duration(milliseconds: 1300),
];

/// Convenient client that captures and returns API errors.
class ApiClient {
  ApiClient(this._log, this._client, {List<Duration> retries = defaultRetries})
      : _retryClient = RetryClient.withDelays(_client, retries,
            whenError: (_, __) => true) {
    _log.info('Creating new ApiClient.');
  }

  final Logger _log;
  final Client _client;
  final RetryClient _retryClient;

  AsyncResult<Response, IOError> get(Uri url,
      {Map<String, String>? headers, bool retry = false}) async {
    try {
      final resp =
          await (retry ? _retryClient : _client).get(url, headers: headers);
      return _validateResponseStatusResult(url, resp);
    } catch (error, trace) {
      _log.severe('Request error', error, trace);
      return Failure(GenericError(trace));
    }
  }

  AsyncResult<Response, IOError> post(Uri url,
      {Map<String, String>? headers,
      Object? body,
      Encoding? encoding,
      bool retry = false}) async {
    try {
      final resp = await (retry ? _retryClient : _client)
          .post(url, headers: headers, body: body, encoding: encoding);
      return _validateResponseStatusResult(url, resp);
    } catch (error, trace) {
      _log.severe('Request error', error, trace);
      return Failure(GenericError(trace));
    }
  }

  AsyncResult<Response, IOError> delete(Uri url,
      {Map<String, String>? headers,
      Object? body,
      Encoding? encoding,
      bool retry = false}) async {
    return Result.tryCatchAsync<Response, IOError>(
        () async => (retry ? _retryClient : _client).delete(url,
            headers: headers, body: body, encoding: encoding), (error, trace) {
      _log.severe('Request error', error, trace);
      return GenericError(trace);
    }).then((res) => res
        .flatMap((response) => _validateResponseStatusResult(url, response)));
  }

  Future<StreamedResponse> stream(Uri url,
      {Map<String, String>? headers}) async {
    final request = Request('GET', url);
    if (headers != null) {
      request.headers.addAll(headers);
    }
    return Result.tryCatchAsync<StreamedResponse, IOError>(() async {
      return _client.send(request);
      // return _validateResponseStatusResult(url, resp);
    }, (error, trace) {
      _log.severe('Request error', error, trace);
      return GenericError(trace);
    }).then((res) => res
        .flatMap((r) => _validateResponseStatusResult(url, r))
        .fold((resp) => resp, (err) => throw err));
  }

  Result<T, IOError> _validateResponseStatusResult<T extends BaseResponse>(
      Uri url, T response) {
    if (response.statusCode >= 500) {
      _log.severe('$url responded with status ${response.statusCode}');
    } else if (response.statusCode >= 400) {
      _log.warning('$url responded with status ${response.statusCode}');
    }
    return response.statusCode < 400
        ? Success(response)
        : response.statusCode == 404
            ? Failure(NotFoundError(StackTrace.current))
            : response.statusCode == 401
                ? Failure(UnauthorizedError(StackTrace.current))
                : response.statusCode == 403
                    ? Failure(ForbiddenError(StackTrace.current))
                    : Failure(ApiRequestError(StackTrace.current));
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

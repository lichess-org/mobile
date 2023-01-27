import 'dart:convert';
import 'package:async/async.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart';
import 'package:result_extensions/result_extensions.dart';
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

  AsyncResult<Response> get(
    Uri url, {
    Map<String, String>? headers,
    bool retry = false,
  }) =>
      Result.capture(
              (retry ? _retryClient : _client).get(url, headers: headers))
          .mapError((error, stackTrace) {
        _log.severe('Request error', error, stackTrace);
        return GenericIOException();
      }).flatMap((response) => _validateResponseStatusResult(url, response));

  AsyncResult<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    bool retry = false,
  }) =>
      Result.capture((retry ? _retryClient : _client)
              .post(url, headers: headers, body: body, encoding: encoding))
          .mapError((error, stackTrace) {
        _log.severe('Request error', error, stackTrace);
        return GenericIOException();
      }).flatMap((response) => _validateResponseStatusResult(url, response));

  AsyncResult<Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    bool retry = false,
  }) =>
      Result.capture((retry ? _retryClient : _client)
              .delete(url, headers: headers, body: body, encoding: encoding))
          .mapError((error, stackTrace) {
        _log.severe('Request error', error, stackTrace);
        return GenericIOException();
      }).flatMap((response) => _validateResponseStatusResult(url, response));

  Future<StreamedResponse> stream(Uri url,
      {Map<String, String>? headers}) async {
    final request = Request('GET', url);
    if (headers != null) {
      request.headers.addAll(headers);
    }
    return Result.capture(_client.send(request))
        .mapError((error, stackTrace) {
          _log.severe('Request error', error, stackTrace);
          return GenericIOException();
        })
        .flatMap((r) => _validateResponseStatusResult(url, r))
        .then((r) => r.getOrThrow());
  }

  Result<T> _validateResponseStatusResult<T extends BaseResponse>(
      Uri url, T response) {
    if (response.statusCode >= 500) {
      _log.severe('$url responded with status ${response.statusCode}');
    } else if (response.statusCode >= 400) {
      _log.warning('$url responded with status ${response.statusCode}');
    }
    return response.statusCode < 400
        ? Result.value(response)
        : response.statusCode == 404
            ? Result.error(NotFoundException())
            : response.statusCode == 401
                ? Result.error(UnauthorizedException())
                : response.statusCode == 403
                    ? Result.error(ForbiddenException())
                    : Result.error(ApiRequestException());
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

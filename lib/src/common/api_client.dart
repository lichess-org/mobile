import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:async/async.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:http/retry.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/model/auth/session_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package_info.dart';
import 'errors.dart';

part 'api_client.g.dart';

const defaultRetries = [
  Duration(milliseconds: 200),
  Duration(milliseconds: 300),
  Duration(milliseconds: 500),
  Duration(milliseconds: 800),
  Duration(milliseconds: 1300),
];

@Riverpod(keepAlive: true)
Client httpClient(HttpClientRef ref) {
  final client = Client();
  ref.onDispose(() {
    client.close();
  });
  return client;
}

@Riverpod(keepAlive: true)
ApiClient apiClient(ApiClientRef ref) {
  final httpClient = ref.watch(httpClientProvider);
  final authClient = _AuthClient(
    ref,
    httpClient,
    Logger('AuthClient'),
  );
  final apiClient = ApiClient(
    Logger('ApiClient'),
    authClient,
  );
  ref.onDispose(() {
    apiClient.close();
  });
  return apiClient;
}

/// Convenient client that captures and returns API errors.
class ApiClient {
  ApiClient(
    this._log,
    this._client, {
    List<Duration> retries = defaultRetries,
  }) : _retryClient = RetryClient.withDelays(
          _client,
          retries,
          whenError: (_, __) => true,
        ) {
    _log.info('Creating new ApiClient.');
  }

  final Logger _log;
  final Client _client;
  final RetryClient _retryClient;

  /// Makes app user agent
  static String userAgent(PackageInfo info, LightUser? user) =>
      '${info.appName}/${info.version} $defaultTargetPlatform ${user != null ? user.id : 'anon.'}';

  FutureResult<Response> get(
    Uri url, {
    Map<String, String>? headers,
    bool retry = false,
  }) =>
      Result.capture(
        (retry ? _retryClient : _client).get(url, headers: headers),
      ).mapError((error, stackTrace) {
        _log.severe('Request error', error, stackTrace);
        return GenericIOException();
      }).flatMap((response) => _validateResponseStatusResult(url, response));

  FutureResult<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    bool retry = false,
  }) =>
      Result.capture(
        (retry ? _retryClient : _client)
            .post(url, headers: headers, body: body, encoding: encoding),
      ).mapError((error, stackTrace) {
        _log.severe('Request error', error, stackTrace);
        return GenericIOException();
      }).flatMap((response) => _validateResponseStatusResult(url, response));

  FutureResult<Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    bool retry = false,
  }) =>
      Result.capture(
        (retry ? _retryClient : _client)
            .delete(url, headers: headers, body: body, encoding: encoding),
      ).mapError((error, stackTrace) {
        _log.severe('Request error', error, stackTrace);
        return GenericIOException();
      }).flatMap((response) => _validateResponseStatusResult(url, response));

  Future<StreamedResponse> stream(
    Uri url, {
    Map<String, String>? headers,
  }) async {
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
    Uri url,
    T response,
  ) {
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
class _AuthClient extends BaseClient {
  _AuthClient(this.ref, this._inner, this._logger);

  final ApiClientRef ref;
  final Client _inner;
  final Logger _logger;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final sessionRepo = ref.read(sessionRepositoryProvider);
    final info = ref.watch(packageInfoProvider);
    final session = await sessionRepo.read();

    if (session != null && !request.headers.containsKey('Authorization')) {
      request.headers['Authorization'] = 'Bearer ${session.token}';
    }

    request.headers['user-agent'] = ApiClient.userAgent(info, session?.user);

    _logger.info('${request.method} ${request.url} ${request.headers}');

    return _inner.send(request);
  }
}

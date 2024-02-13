import 'dart:convert';

import 'package:async/async.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';
import 'package:lichess_mobile/src/crashlytics.dart';
import 'package:lichess_mobile/src/http_client.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';
import 'package:lichess_mobile/src/model/common/errors.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/utils/device_info.dart';
import 'package:lichess_mobile/src/utils/package_info.dart';
import 'package:logging/logging.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_client.g.dart';

@Riverpod(keepAlive: true)
AuthClient authClient(AuthClientRef ref) {
  final httpClient = ref.watch(httpClientProvider);
  final crashlytics = ref.watch(crashlyticsProvider);
  return AuthClient(
    httpClient,
    ref,
    Logger('AuthClient'),
    crashlytics,
  );
}

@riverpod
String userAgent(UserAgentRef ref) {
  final pInfo = ref.read(packageInfoProvider);
  final deviceInfo = ref.read(deviceInfoProvider);
  final sri = ref.read(sriProvider);

  final session = ref.watch(authSessionProvider);

  return makeUserAgent(pInfo, deviceInfo, sri, session?.user);
}

/// HTTP client to communicate with lichess
///
/// This client handles all of the following:
///   - automatically add the Authorization header when a token has been stored,
///   - automatically retry requests on failure,
///   - sends user agent
///   - capture all errors and return a [Result] instead.
///   (TODO) - log the user out when a 401 is received,
class AuthClient {
  AuthClient(
    Client client,
    ProviderRef<dynamic> ref,
    this._log,
    this._crashlytics, {
    List<Duration> retryDelays = defaultRetries,
  })  : _client = _AuthClient(ref, client, _log),
        _retryClient = RetryClient.withDelays(
          _AuthClient(ref, client, _log),
          retryDelays,
        ) {
    _log.info('Creating new ${_log.name}.');
  }

  final Logger _log;
  final Client _client;
  final RetryClient _retryClient;
  final FirebaseCrashlytics _crashlytics;

  FutureResult<Response> get(
    Uri url, {
    Map<String, String>? headers,
    bool retryOnError = true,
  }) =>
      Result.capture(
        (retryOnError ? _retryClient : _client).get(url, headers: headers),
      ).mapError((error, stackTrace) {
        _recordError('GET', error, stackTrace, url, headers);
        return GenericIOException();
      }).flatMap(
        (response) => _validateResponseStatusResult('GET', url, response),
      );

  FutureResult<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    bool retryOnError = true,
  }) =>
      Result.capture(
        (retryOnError ? _retryClient : _client)
            .post(url, headers: headers, body: body, encoding: encoding),
      ).mapError((error, stackTrace) {
        _recordError('POST', error, stackTrace, url, headers);
        return GenericIOException();
      }).flatMap(
        (response) => _validateResponseStatusResult('POST', url, response),
      );

  FutureResult<Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    bool retryOnError = true,
  }) =>
      Result.capture(
        (retryOnError ? _retryClient : _client)
            .delete(url, headers: headers, body: body, encoding: encoding),
      ).mapError((error, stackTrace) {
        _recordError('DELETE', error, stackTrace, url, headers);
        return GenericIOException();
      }).flatMap(
        (response) => _validateResponseStatusResult('DELETE', url, response),
      );

  Result<T> _validateResponseStatusResult<T extends BaseResponse>(
    String method,
    Uri url,
    T response,
  ) {
    if (response.statusCode >= 400) {
      final body = response is Response ? response.body : '';
      _log.warning(
        '$method $url responded with status ${response.statusCode}\n$body',
      );
      if (kReleaseMode) {
        _crashlytics.recordError(
          'Server error: ${response.statusCode}',
          null,
          reason: 'server error',
          information: [
            'url: $url',
            'method: $method',
          ],
        );
      }
    }

    return response.statusCode < 400
        ? Result.value(response)
        : response.statusCode == 404
            ? Result.error(NotFoundException())
            : response.statusCode == 401
                ? Result.error(UnauthorizedException())
                : response.statusCode == 403
                    ? Result.error(ForbiddenException())
                    : Result.error(
                        ApiRequestException(
                          response.statusCode,
                          response is Response ? response.body : '',
                        ),
                      );
  }

  void _recordError(
    String method,
    Object error,
    StackTrace? stackTrace,
    Uri url,
    Map<String, String>? headers,
  ) {
    // Ignore canceling seek requests
    if (error is ClientException && url.path.contains('api/board/seek')) {
      return;
    }
    _log.severe('Request error', error, stackTrace);
    if (kReleaseMode) {
      _crashlytics.recordError(
        error,
        stackTrace,
        reason: 'a non-fatal http request error',
        information: [
          'method: $method',
          'url: $url',
          'headers: $headers',
        ],
      );
    }
  }
}

/// Http client that sets the Authorization header when a token has been stored.
class _AuthClient extends BaseClient {
  _AuthClient(this.ref, this._inner, this._logger);

  final ProviderRef<dynamic> ref;
  final Client _inner;
  final Logger _logger;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final session = ref.read(authSessionProvider);
    final pInfo = ref.read(packageInfoProvider);
    final deviceInfo = ref.read(deviceInfoProvider);
    final sri = ref.read(sriProvider);

    if (session != null && !request.headers.containsKey('Authorization')) {
      final bearer = signBearerToken(session.token);
      request.headers['Authorization'] = 'Bearer $bearer';
    }

    request.headers['user-agent'] =
        makeUserAgent(pInfo, deviceInfo, sri, session?.user);

    _logger.info('${request.method} ${request.url}', request.headers);

    return _inner.send(request);
  }
}

const defaultRetries = [
  Duration(milliseconds: 300),
  Duration(milliseconds: 500),
  Duration(milliseconds: 800),
];

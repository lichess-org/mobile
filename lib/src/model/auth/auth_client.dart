import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:async/async.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:http/retry.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/http_client.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/common/errors.dart';
import 'package:lichess_mobile/src/utils/package_info.dart';

part 'auth_client.g.dart';

@Riverpod(keepAlive: true)
AuthClient authClient(AuthClientRef ref) {
  final httpClient = ref.watch(httpClientProvider);
  final logger = Logger('AuthClient');
  final insideAuthClient = _AuthClient(
    ref,
    httpClient,
    logger,
  );
  final authClient = AuthClient(
    logger,
    insideAuthClient,
  );
  ref.onDispose(() {
    authClient.close();
  });
  return authClient;
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
    this._log,
    this._client, {
    List<Duration> retryDelays = defaultRetries,
  })  : _retryClient = RetryClient.withDelays(
          _client,
          retryDelays,
        ),
        _retryClientOnError = RetryClient.withDelays(
          _client,
          retryDelays,
          whenError: (error, _) async => error is SocketException,
        ) {
    _log.info('Creating new AuthClient.');
  }

  final Logger _log;
  final Client _client;
  final RetryClient _retryClient;
  final RetryClient _retryClientOnError;

  /// Makes app user agent
  static String userAgent(PackageInfo info, LightUser? user) =>
      '${info.appName}/${info.version} $defaultTargetPlatform ${user != null ? user.id : 'anon.'}';

  FutureResult<Response> get(
    Uri url, {
    Map<String, String>? headers,
    bool retryOnError = true,
  }) =>
      Result.capture(
        (retryOnError ? _retryClientOnError : _retryClient)
            .get(url, headers: headers),
      ).mapError((error, stackTrace) {
        _log.severe('Request error', error, stackTrace);
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
        (retryOnError ? _retryClientOnError : _retryClient)
            .post(url, headers: headers, body: body, encoding: encoding),
      ).mapError((error, stackTrace) {
        _log.severe('Request error', error, stackTrace);
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
        (retryOnError ? _retryClientOnError : _retryClient)
            .delete(url, headers: headers, body: body, encoding: encoding),
      ).mapError((error, stackTrace) {
        _log.severe('Request error', error, stackTrace);
        return GenericIOException();
      }).flatMap(
        (response) => _validateResponseStatusResult('DELETE', url, response),
      );

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
        .flatMap((r) => _validateResponseStatusResult('GET', url, r))
        .then((r) => r.getOrThrow());
  }

  Result<T> _validateResponseStatusResult<T extends BaseResponse>(
    String method,
    Uri url,
    T response,
  ) {
    if (response.statusCode >= 500) {
      _log.severe('$method $url responded with status ${response.statusCode}');
    } else if (response.statusCode >= 400) {
      final body = response is Response ? response.body : '';
      _log.warning(
        '$method $url responded with status ${response.statusCode}\n$body',
      );
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
    _log.info('Closing AuthClient.');
    _client.close();
    _retryClient.close();
  }
}

/// Http client that sets the Authorization header when a token has been stored.
class _AuthClient extends BaseClient {
  _AuthClient(this.ref, this._inner, this._logger);

  final AuthClientRef ref;
  final Client _inner;
  final Logger _logger;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final session = ref.read(authSessionProvider);
    final info = ref.read(packageInfoProvider);

    if (session != null && !request.headers.containsKey('Authorization')) {
      request.headers['Authorization'] = 'Bearer ${session.token}';
    }

    request.headers['user-agent'] = AuthClient.userAgent(info, session?.user);

    _logger.info('${request.method} ${request.url}', request.headers);

    return _inner.send(request);
  }
}

const defaultRetries = [
  Duration(milliseconds: 200),
  Duration(milliseconds: 300),
  Duration(milliseconds: 500),
  Duration(milliseconds: 800),
];

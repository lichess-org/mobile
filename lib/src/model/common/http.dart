import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart'
    show
        BaseClient,
        BaseRequest,
        BaseResponse,
        Client,
        ClientException,
        Response,
        StreamedResponse;
import 'package:http/io_client.dart';
import 'package:http/retry.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/device_info.dart';
import 'package:lichess_mobile/src/utils/package_info.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http.g.dart';

final _logger = Logger('HttpClient');

// const _maxCacheSize = 2 * 1024 * 1024;

/// Creates the appropriate http client for the platform.
Client httpClient(PackageInfo pInfo) {
  // TODO wait for https://github.com/dart-lang/http/pull/1111
  // to be merged and released before using embedded Cronet on Android.
  // if (Platform.isAndroid) {
  //   final engine = CronetEngine.build(
  //     cacheMode: CacheMode.memory,
  //     cacheMaxSize: _maxCacheSize,
  //     userAgent: userAgent,
  //   );
  //   return CronetClient.fromCronetEngine(engine);
  // }

  // CupertinoClient doesn't close the connection when the client is closed.
  // See: https://github.com/dart-lang/http/issues/1131
  // TODO: We might want to still use it and fallback to IOClient for creating
  // game seeks which must be cancellable.
  // if (Platform.isIOS || Platform.isMacOS) {
  //   final config = URLSessionConfiguration.ephemeralSessionConfiguration()
  //     ..cache = URLCache.withCapacity(memoryCapacity: _maxCacheSize)
  //     ..httpAdditionalHeaders = {'User-Agent': userAgent};
  //   return CupertinoClient.fromSessionConfiguration(config);
  // }

  return IOClient(HttpClient()..userAgent = 'Lichess Mobile/${pInfo.version}');
}

@Riverpod(keepAlive: true)
LichessClientFactory lichessClientFactory(LichessClientFactoryRef ref) {
  return LichessClientFactory(ref);
}

/// Factory for the default [Client] used to send requests to lichess server.
///
/// It creates a client that:
/// - Retries just once, after 500ms, on 429 Too Many Requests.
/// - Sets the Authorization header when a token has been stored.
/// - Sets the user-agent header with the app version, build number, and device info.
/// - Logs all requests and responses with status code >= 400.
///
/// This class should be overridden in tests to provide a mock client.
class LichessClientFactory {
  LichessClientFactory(this._ref);

  final LichessClientFactoryRef _ref;

  Client call() {
    // Retry just once, after 500ms, on 429 Too Many Requests.
    // TODO consider throttling the requests, instead of retrying.
    return RetryClient(
      AuthClient(httpClient(_ref.read(packageInfoProvider)), _ref),
      retries: 1,
      delay: _defaultDelay,
      when: (response) => response.statusCode == 429,
    );
  }
}

Duration _defaultDelay(int retryCount) =>
    const Duration(milliseconds: 900) * math.pow(1.5, retryCount);

@Riverpod(keepAlive: true)
String userAgent(UserAgentRef ref) {
  final session = ref.watch(authSessionProvider);

  return makeUserAgent(
    ref.read(packageInfoProvider),
    ref.read(deviceInfoProvider),
    ref.read(sriProvider),
    session?.user,
  );
}

/// Creates a user-agent string with the app version, build number, and device info and possibly the user ID if a user is logged in.
String makeUserAgent(
  PackageInfo info,
  BaseDeviceInfo deviceInfo,
  String sri,
  LightUser? user,
) {
  final base =
      'Lichess Mobile/${info.version} as:${user?.id ?? 'anon'} sri:$sri';

  if (deviceInfo is AndroidDeviceInfo) {
    return '$base os:Android/${deviceInfo.version.release} dev:${deviceInfo.model}';
  } else if (deviceInfo is IosDeviceInfo) {
    return '$base os:iOS/${deviceInfo.systemVersion} dev:${deviceInfo.model}';
  }

  return base;
}

/// Http client that sets the Authorization header when a token has been stored.
///
/// Also sets the user-agent header with the app version, build number, and device info.
/// If the user is logged in, it also includes the user's id.
///
/// Logs all requests and responses with status code >= 400.
class AuthClient extends BaseClient {
  AuthClient(this._inner, this._ref);

  final LichessClientFactoryRef _ref;
  final Client _inner;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final session = _ref.read(authSessionProvider);

    if (session != null && !request.headers.containsKey('Authorization')) {
      final bearer = signBearerToken(session.token);
      request.headers['Authorization'] = 'Bearer $bearer';
    }
    request.headers['User-Agent'] = makeUserAgent(
      _ref.read(packageInfoProvider),
      _ref.read(deviceInfoProvider),
      _ref.read(sriProvider),
      session?.user,
    );

    _logger.info(
      '${request.method} ${request.url} ${request.headers['User-Agent']}',
    );

    try {
      final response = await _inner.send(request);

      _logIfError(response);

      return response;
    } catch (e, st) {
      _logger.warning('Request to ${request.url} failed: $e', e, st);
      rethrow;
    }
  }

  void _logIfError(BaseResponse response) {
    if (response.request != null && response.statusCode >= 400) {
      final request = response.request!;
      final method = request.method;
      final url = request.url;
      // TODD for now logging isn't much useful
      // We could use improve it later to create an http logger in the app.
      _logger.warning(
        '$method $url responded with status ${response.statusCode} ${response.reasonPhrase}',
      );
    }
  }

  @override
  void close() {
    _inner.close();
  }
}

extension ClientExtension on Client {
  /// Sends an HTTP GET request with the given headers to the given URL and
  /// returns a Future that completes to the body of the response as a JSON object
  /// mapped to [T].
  ///
  /// The Future will emit a [ClientException] if the response doesn't have a
  /// success status code or if the response body can't be read as a json object.
  Future<T> readJson<T>(
    Uri url, {
    Map<String, String>? headers,
    required T Function(Map<String, dynamic>) mapper,
  }) async {
    final response = await get(url, headers: headers);
    _checkResponseSuccess(url, response);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (json is! Map<String, dynamic>) {
      _logger.severe('Could not read json object as $T: expected an object.');
      throw ClientException(
        'Could not read json object as $T: expected an object.',
        url,
      );
    }
    try {
      return mapper(json);
    } catch (e, st) {
      _logger.severe('Could not read json object as $T: $e', e, st);
      throw ClientException(
        'Could not read json object as $T: $e',
        url,
      );
    }
  }

  /// Sends an HTTP GET request with the given headers to the given URL and
  /// returns a Future that completes to the body of the response as a JSON list
  /// of objects mapped to [T].
  ///
  /// The Future will emit a [ClientException] if the response doesn't have a
  /// success status code or if the response body can't be read as a json list.
  Future<IList<T>> readJsonList<T>(
    Uri url, {
    Map<String, String>? headers,
    required T Function(Map<String, dynamic>) mapper,
  }) async {
    final response = await get(url, headers: headers);
    _checkResponseSuccess(url, response);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (json is! List<dynamic>) {
      _logger.severe('Could not read json object as List: expected a list.');
      throw ClientException(
        'Could not read json object as List: expected a list.',
        url,
      );
    }

    return IList(
      json.map((e) {
        if (e is! Map<String, dynamic>) {
          _logger.severe('Could not read json object as $T');
          throw ClientException('Could not read json object as $T', url);
        }
        try {
          return mapper(e);
        } catch (e, st) {
          _logger.severe('Could not read json object as $T: $e', e, st);
          throw ClientException('Could not read json object as $T: $e', url);
        }
      }),
    );
  }

  /// Sends an HTTP GET request with the given headers to the given URL and
  /// returns a Future that completes to the body of the response as a ND-JSON
  /// list of objects mapped to [T].
  ///
  /// The Future will emit a [ClientException] if the response doesn't have a
  /// success status code or if the response body can't be read as a ND-JSON list.
  Future<IList<T>> readNdJsonList<T>(
    Uri url, {
    Map<String, String>? headers,
    required T Function(Map<String, dynamic>) mapper,
  }) async {
    final response = await get(url, headers: headers);
    _checkResponseSuccess(url, response);
    try {
      final json = LineSplitter.split(utf8.decode(response.bodyBytes))
          .where((e) => e.isNotEmpty && e != '\n')
          .map((e) => jsonDecode(e) as Map<String, dynamic>);
      return IList(json.map(mapper));
    } catch (e) {
      _logger.severe('Could not read nd-json objects as List<$T>.');
      throw ClientException(
        'Could not read nd-json objects as List<$T>.',
        url,
      );
    }
  }

  /// Sends an HTTP POST request with the given headers and body to the given URL and
  /// returns a Future that completes to the body of the response as a JSON object
  /// mapped to [T].
  ///
  /// The Future will emit a [ClientException] if the response doesn't have a
  /// success status code or if the response body can't be read as a json object.
  Future<T> postReadJson<T>(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    required T Function(Map<String, dynamic>) mapper,
  }) async {
    final response =
        await post(url, headers: headers, body: body, encoding: encoding);
    _checkResponseSuccess(url, response);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (json is! Map<String, dynamic>) {
      _logger.severe('Could not read json object as $T: expected an object.');
      throw ClientException(
        'Could not read json object as $T: expected an object.',
        url,
      );
    }
    try {
      return mapper(json);
    } catch (e, st) {
      _logger.severe('Could not read json as $T: $e', e, st);
      throw ClientException(
        'Could not read json as $T: $e',
        url,
      );
    }
  }

  /// Sends an HTTP POST request with the given headers and body to the given URL and
  /// returns a Future that completes to the body of the response as a JSON list
  /// of objects mapped to [T].
  ///
  /// The Future will emit a [ClientException] if the response doesn't have a
  /// success status code or if the response body can't be read as a json list.
  Future<IList<T>> postReadNdJsonList<T>(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    required T Function(Map<String, dynamic>) mapper,
  }) async {
    final response =
        await post(url, headers: headers, body: body, encoding: encoding);
    _checkResponseSuccess(url, response);
    try {
      final json = LineSplitter.split(utf8.decode(response.bodyBytes))
          .where((e) => e.isNotEmpty && e != '\n')
          .map((e) => jsonDecode(e) as Map<String, dynamic>);
      return IList(json.map(mapper));
    } catch (e) {
      _logger.severe('Could not read nd-json objects as List<$T>.');
      throw ClientException(
        'Could not read nd-json objects as List<$T>.',
        url,
      );
    }
  }

  /// Throws an error if [response] is not successful.
  void _checkResponseSuccess(Uri url, Response response) {
    if (response.statusCode < 400) return;
    var message = 'Request to $url failed with status ${response.statusCode}';
    if (response.reasonPhrase != null) {
      message = '$message: ${response.reasonPhrase}';
    }
    throw ClientException('$message.', url);
  }
}

extension ClientWidgetRefExtension on WidgetRef {
  /// Runs [fn] with a [Client] configured to send requests to lichess server.
  ///
  /// It handles the creation and closing of the client, while trying to reuse
  /// the same client for multiple requests at the same time.
  /// Will try to close the client after [fn] completes.
  Future<T> withClient<T>(Future<T> Function(Client) fn) async {
    final (client, key) =
        _ReuseClientService.instance.get(read(lichessClientFactoryProvider));
    try {
      return await fn(client);
    } finally {
      _ReuseClientService.instance.close(key);
    }
  }
}

extension ClientRefExtension on Ref {
  /// Runs [fn] with an [Client] configured to send requests to lichess server.
  ///
  /// It handles the creation and closing of the client, while trying to reuse
  /// the same client for multiple requests at the same time.
  /// Will try to close the client after [fn] completes, or when the provider is
  /// disposed.
  Future<T> withClient<T>(Future<T> Function(Client) fn) async {
    final (client, key) =
        _ReuseClientService.instance.get(read(lichessClientFactoryProvider));
    onDispose(() => _ReuseClientService.instance.close(key));
    try {
      return await fn(client);
    } finally {
      _ReuseClientService.instance.close(key);
    }
  }
}

extension ClientAutoDisposeRefExtension<T> on AutoDisposeRef<T> {
  /// Runs [fn] with an [Client] configured to send requests to lichess server,
  /// and keeps the provider alive for [duration].
  ///
  /// This is primarily used for caching network requests in a [FutureProvider].
  ///
  /// It handles the creation and closing of the client, while trying to reuse
  /// the same client for multiple requests at the same time.
  /// Will try to close the client after [fn] completes, or when the provider is
  /// disposed.
  ///
  /// If [fn] throws with a [SocketException], the provider is not kept alive, this
  /// allows to retry the request later.
  Future<U> withClientCacheFor<U>(
    Future<U> Function(Client) fn,
    Duration duration,
  ) async {
    final link = keepAlive();
    final timer = Timer(duration, link.close);
    final (client, key) =
        _ReuseClientService.instance.get(read(lichessClientFactoryProvider));
    onDispose(() {
      _ReuseClientService.instance.close(key);
      timer.cancel();
    });
    try {
      return await fn(client);
    } on SocketException catch (_) {
      link.close();
      rethrow;
    } finally {
      _ReuseClientService.instance.close(key);
    }
  }
}

/// A service that reuses the same http client for multiple requests at the same
/// time, and closes it when there are no more pending requests.
class _ReuseClientService {
  _ReuseClientService._();

  static final instance = _ReuseClientService._();

  Client? _client;
  Set<UniqueKey> _clientKeys = {};

  /// Returns the client and a unique key to be used to close it later.
  ///
  /// If the client is null, it creates a new one.
  (Client, UniqueKey) get(LichessClientFactory factory) {
    if (_client == null) {
      _logger.fine('Creating a new client.');
    }
    if (_client == null) {
      _client = factory();
      _clientKeys = {};
    }
    final key = UniqueKey();
    _clientKeys.add(key);
    return (_client!, key);
  }

  /// Asks to close the client with the given key.
  ///
  /// If there are no more keys, it closes the client.
  Future<void> close(UniqueKey key) async {
    // give some time for other requests to reuse the client, unless we are
    // running tests, as we don't want the timer to interfere with them.
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    _clientKeys.remove(key);
    if (_clientKeys.isEmpty && _client != null) {
      _logger.fine('Closing client after all users have closed.');
      _client!.close();
      _client = null;
    }
  }
}

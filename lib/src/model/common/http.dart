import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
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

@Riverpod(keepAlive: true)
AuthClientFactory authClientFactory(AuthClientFactoryRef ref) {
  final pInfo = ref.read(packageInfoProvider);
  final deviceInfo = ref.read(deviceInfoProvider);
  final sri = ref.read(sriProvider);
  final userAgent = makeUserAgent(pInfo, deviceInfo, sri, null);
  return AuthClientFactory(ref, userAgent);
}

class AuthClientFactory {
  AuthClientFactory(this._ref, this._userAgent);

  final AuthClientFactoryRef _ref;

  final String _userAgent;

  Client call() {
    return AuthClient(httpClient(_userAgent), _ref);
  }
}

// const _maxCacheSize = 2 * 1024 * 1024;

/// Creates the appropriate http client for the platform.
Client httpClient(String userAgent) {
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

  // if (Platform.isIOS || Platform.isMacOS) {
  //   final config = URLSessionConfiguration.ephemeralSessionConfiguration()
  //     ..cache = URLCache.withCapacity(memoryCapacity: _maxCacheSize)
  //     ..httpAdditionalHeaders = {'User-Agent': userAgent};
  //   return CupertinoClient.fromSessionConfiguration(config);
  // }

  return IOClient(HttpClient()..userAgent = userAgent);
}

/// Http client that sets the Authorization header when a token has been stored.
///
/// Also sets the user-agent header with the app version, build number, and device info.
/// If the user is logged in, it also includes the user's id.
///
/// Logs all requests and responses with status code >= 400.
class AuthClient extends BaseClient {
  AuthClient(this._inner, this._ref);

  final AuthClientFactoryRef _ref;
  final Client _inner;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final session = _ref.read(authSessionProvider);

    if (session != null && !request.headers.containsKey('Authorization')) {
      final bearer = signBearerToken(session.token);
      request.headers['Authorization'] = 'Bearer $bearer';
      request.headers['User-Agent'] = makeUserAgent(
        _ref.read(packageInfoProvider),
        _ref.read(deviceInfoProvider),
        _ref.read(sriProvider),
        session.user,
      );
    }

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
    return mapper(json);
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
        return mapper(e);
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
    return mapper(json);
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

extension ClientRefExtension on Ref {
  /// Runs [fn] with an [AuthClient].
  ///
  /// The client is automatically closed after [fn] completes or when the
  /// provider is disposed.
  Future<T> withAuthClient<T>(Future<T> Function(Client) fn) async {
    final client = read(authClientFactoryProvider)();
    onDispose(client.close);
    try {
      return await fn(client);
    } finally {
      client.close();
    }
  }
}

extension ClientAutoDisposeRefExtension<T> on AutoDisposeRef<T> {
  /// Runs [fn] with an [AuthClient] and keeps the provider alive for [duration].
  /// This is primarily used for caching network requests in a [FutureProvider].
  ///
  /// The client is automatically closed after [fn] completes or when the
  /// provider is disposed.
  ///
  /// If [fn] throws with a [SocketException], the provider is not kept alive, this
  /// allows to retry the request later.
  Future<U> withAuthClientCacheFor<U>(
    Future<U> Function(Client) fn,
    Duration duration,
  ) async {
    final link = keepAlive();
    final timer = Timer(duration, link.close);
    final client = read(authClientFactoryProvider)();
    onDispose(() {
      client.close();
      timer.cancel();
    });
    try {
      return await fn(client);
    } on SocketException catch (_) {
      link.close();
      rethrow;
    } finally {
      client.close();
    }
  }
}

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

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:cronet_http/cronet_http.dart';
import 'package:cupertino_http/cupertino_http.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart'
    show
        BaseRequest,
        BaseResponse,
        Client,
        ClientException,
        Request,
        Response,
        StreamedResponse;
import 'package:http/io_client.dart';
import 'package:http/retry.dart';
import 'package:lichess_mobile/src/constants.dart';
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

const _maxCacheSize = 2 * 1024 * 1024;

/// Creates a Uri pointing to lichess server with the given unencoded path and query parameters.
Uri lichessUri(String unencodedPath, [Map<String, dynamic>? queryParameters]) =>
    kLichessHost.startsWith('localhost')
        ? Uri.http(kLichessHost, unencodedPath, queryParameters)
        : Uri.https(kLichessHost, unencodedPath, queryParameters);

/// Creates the appropriate http client for the platform.
Client httpClientFactory() {
  const userAgent = 'Lichess Mobile';
  if (Platform.isAndroid) {
    final engine = CronetEngine.build(
      cacheMode: CacheMode.memory,
      cacheMaxSize: _maxCacheSize,
      userAgent: userAgent,
    );
    return CronetClient.fromCronetEngine(engine);
  }

  if (Platform.isIOS || Platform.isMacOS) {
    final config = URLSessionConfiguration.ephemeralSessionConfiguration()
      ..cache = URLCache.withCapacity(memoryCapacity: _maxCacheSize)
      ..httpAdditionalHeaders = {'User-Agent': userAgent};
    return CupertinoClient.fromSessionConfiguration(config);
  }

  return IOClient(HttpClient()..userAgent = userAgent);
}

/// The default http client.
///
/// This client is used for all requests that don't go to the lichess server, for
/// example, requests to lichess CDN, or other APIs.
/// Only one instance of this client is created and kept alive for the whole app.
@Riverpod(keepAlive: true)
Client defaultClient(DefaultClientRef ref) {
  final client = httpClientFactory();
  ref.onDispose(() => client.close());
  return client;
}

/// The http client configured to make requests to the lichess API.
///
/// Only one instance of this client is created and kept alive for the whole app.
@Riverpod(keepAlive: true)
LichessClient lichessClient(LichessClientRef ref) {
  final client = LichessClient(
    // Retry just once, after 500ms, on 429 Too Many Requests.
    RetryClient(
      httpClientFactory(),
      retries: 1,
      delay: _defaultDelay,
      when: (response) => response.statusCode == 429,
    ),
    ref,
  );
  ref.onDispose(() => client.close());
  return client;
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

/// Lichess HTTP client.
///
/// - All requests go to the lichess server, defined in [kLichessHost].
/// - Sets the Authorization header when a token has been stored.
/// - Sets the user-agent header with the app version, build number, and device info. If the user is logged in, it also includes the user's id.
/// - Logs all requests and responses with status code >= 400.
class LichessClient implements Client {
  LichessClient(this._inner, this._ref);

  final LichessClientRef _ref;
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
      _logger.warning(
        '$method $url responded with status ${response.statusCode} ${response.reasonPhrase}',
      );
    }
  }

  @override
  void close() {
    _inner.close();
  }

  @override
  Future<Response> head(
    Uri url, {
    Map<String, String>? headers,
  }) =>
      _sendUnstreamed('HEAD', url, headers);

  @override
  Future<Response> get(
    Uri url, {
    Map<String, String>? headers,
  }) =>
      _sendUnstreamed('GET', url, headers);

  @override
  Future<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      _sendUnstreamed('POST', url, headers, body, encoding);

  @override
  Future<Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      _sendUnstreamed('PUT', url, headers, body, encoding);

  @override
  Future<Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      _sendUnstreamed('PATCH', url, headers, body, encoding);

  @override
  Future<Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      _sendUnstreamed('DELETE', url, headers, body, encoding);

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) async {
    final response = await get(url, headers: headers);
    _checkResponseSuccess(url, response);
    return response.body;
  }

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) async {
    final response = await get(url, headers: headers);
    _checkResponseSuccess(url, response);
    return response.bodyBytes;
  }

  /// Sends a non-streaming [Request] and returns a non-streaming [Response].
  Future<Response> _sendUnstreamed(
    String method,
    Uri url,
    Map<String, String>? headers, [
    Object? body,
    Encoding? encoding,
  ]) async {
    final request = Request(
      method,
      lichessUri(url.path, url.hasQuery ? url.queryParameters : null),
    );

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

    return Response.fromStream(await send(request));
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

/// A JSON decoder that decodes UTF-8 bytes.
///
/// This is a fusion of [Utf8Decoder] and [JsonDecoder] which is more efficient
/// than decoding the bytes to a string and then parsing the JSON.
final jsonUtf8Decoder = const Utf8Decoder().fuse(const JsonDecoder());

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
    final json = jsonUtf8Decoder.convert(response.bodyBytes);
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
    required T? Function(Map<String, dynamic>) mapper,
  }) async {
    final response = await get(url, headers: headers);
    _checkResponseSuccess(url, response);
    final json = jsonUtf8Decoder.convert(response.bodyBytes);
    if (json is! List<dynamic>) {
      _logger.severe('Could not read json object as List: expected a list.');
      throw ClientException(
        'Could not read json object as List: expected a list.',
        url,
      );
    }

    final List<T> list = [];
    for (final e in json) {
      if (e is! Map<String, dynamic>) {
        _logger.severe('Could not read json object as $T: expected an object.');
        throw ClientException(
          'Could not read json object as $T: expected an object.',
          url,
        );
      }
      try {
        final mapped = mapper(e);
        if (mapped != null) {
          list.add(mapped);
        }
      } catch (e, st) {
        _logger.severe('Could not read json object as $T: $e', e, st);
        throw ClientException('Could not read json object as $T: $e', url);
      }
    }
    return IList(list);
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
    int Function(T, T)? compare,
  }) async {
    final response = await get(url, headers: headers);
    _checkResponseSuccess(url, response);
    try {
      final json = LineSplitter.split(utf8.decode(response.bodyBytes))
          .where((e) => e.isNotEmpty && e != '\n')
          .map((e) => jsonDecode(e) as Map<String, dynamic>);
      final result = json.map(mapper);
      if (compare == null) {
        return IList(result);
      } else {
        return IList(result.sorted(compare));
      }
    } catch (e) {
      _logger.severe('Could not read nd-json objects as List<$T>.');
      throw ClientException(
        'Could not read nd-json objects as List<$T>: $e',
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
    final json = jsonUtf8Decoder.convert(response.bodyBytes);
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
}

extension ClientWidgetRefExtension on WidgetRef {
  /// Runs [fn] with a [LichessClient].
  Future<T> withClient<T>(Future<T> Function(LichessClient) fn) async {
    final client = read(lichessClientProvider);
    return await fn(client);
  }
}

extension ClientRefExtension on Ref {
  /// Runs [fn] with a [LichessClient].
  Future<T> withClient<T>(Future<T> Function(LichessClient) fn) async {
    final client = read(lichessClientProvider);
    return await fn(client);
  }
}

extension ClientAutoDisposeRefExtension<T> on AutoDisposeRef<T> {
  /// Runs [fn] with a [LichessClient] and keeps the provider alive for [duration].
  ///
  /// This is primarily used for caching network requests in a [FutureProvider].
  ///
  /// If [fn] throws with a [SocketException], the provider is not kept alive, this
  /// allows to retry the request later.
  Future<U> withClientCacheFor<U>(
    Future<U> Function(LichessClient) fn,
    Duration duration,
  ) async {
    final link = keepAlive();
    final timer = Timer(duration, link.close);
    final client = read(lichessClientProvider);
    onDispose(() {
      timer.cancel();
    });
    try {
      return await fn(client);
    } on SocketException catch (_) {
      link.close();
      rethrow;
    }
  }
}

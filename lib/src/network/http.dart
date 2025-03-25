import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:cronet_http/cronet_http.dart';
import 'package:cupertino_http/cupertino_http.dart';
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
        Request,
        Response,
        StreamedResponse;
import 'package:http/io_client.dart';
import 'package:http/retry.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/http_log/http_log_storage.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http.g.dart';

final _logger = Logger('HttpClient');

const _maxCacheSize = 2 * 1024 * 1024;

/// Creates a Uri pointing to lichess server with the given unencoded path and query parameters.
Uri lichessUri(String unencodedPath, [Map<String, dynamic>? queryParameters]) =>
    kLichessHost.startsWith('localhost') ||
            kLichessHost.startsWith('10.') ||
            kLichessHost.startsWith('192.168.')
        ? Uri.http(kLichessHost, unencodedPath, queryParameters)
        : Uri.https(kLichessHost, unencodedPath, queryParameters);

/// Creates the appropriate http client for the platform.
///
/// Do not use directly, use [defaultClient] or [lichessClient] instead.
class HttpClientFactory {
  const HttpClientFactory({this.wrapper});

  final Client Function(Client client)? wrapper;

  Client _createClient() {
    const userAgent = 'Lichess Mobile';
    if (Platform.isAndroid) {
      final engine = CronetEngine.build(
        cacheMode: CacheMode.memory,
        cacheMaxSize: _maxCacheSize,
        userAgent: userAgent,
      );
      return CronetClient.fromCronetEngine(engine);
    } else if (Platform.isIOS || Platform.isMacOS) {
      final config =
          URLSessionConfiguration.ephemeralSessionConfiguration()
            ..cache = URLCache.withCapacity(memoryCapacity: _maxCacheSize)
            ..httpAdditionalHeaders = {'User-Agent': userAgent};
      return CupertinoClient.fromSessionConfiguration(config);
    } else {
      return IOClient(HttpClient()..userAgent = userAgent);
    }
  }

  Client call() {
    final client = _createClient();
    return wrapper?.call(client) ?? client;
  }
}

/// The global [HttpClientFactory] provider.
///
/// Http clients created by this factory log all requests and responses to the database.
@Riverpod(keepAlive: true)
HttpClientFactory httpClientFactory(Ref ref) {
  return HttpClientFactory(
    wrapper:
        (client) => _RegisterCallbackClient(
          client,
          onRequest: (request) async {
            if (request.method == 'HEAD') return;
            final httpLogStorage = await ref.read(httpLogStorageProvider.future);
            httpLogStorage.save(
              HttpLogEntry(
                httpLogId: request.hashCode.toString(),
                requestDateTime: DateTime.now(),
                requestMethod: request.method,
                requestUrl: request.url,
              ),
            );
          },
          onResponse: (response) async {
            if (response.request != null) {
              final httpLogStorage = await ref.read(httpLogStorageProvider.future);
              httpLogStorage.updateWithResponse(
                response.request!.hashCode.toString(),
                responseCode: response.statusCode,
                responseDateTime: DateTime.now(),
              );
            }
          },
          onError: (request, error, [st]) async {
            if (request.method == 'HEAD') return;
            final httpLogStorage = await ref.read(httpLogStorageProvider.future);
            if (error is ClientException) {
              httpLogStorage.updateWithError(
                request.hashCode.toString(),
                errorMessage: error.message,
              );
            } else {
              httpLogStorage.updateWithError(
                request.hashCode.toString(),
                errorMessage: error.toString(),
              );
            }
          },
        ),
  );
}

/// The default http client.
///
/// This client is used for all requests that don't go to the lichess server, for
/// example, requests to lichess CDN, or other APIs.
/// Only one instance of this client is created and kept alive for the whole app.
@Riverpod(keepAlive: true)
Client defaultClient(Ref ref) {
  final client = _RegisterCallbackClient(
    ref.read(httpClientFactoryProvider)(),
    onRequest: (request) => _logger.info('${request.method} ${request.url}'),
  );
  ref.onDispose(() => client.close());
  return client;
}

/// The http client configured to make requests to the lichess API.
///
/// Only one instance of this client is created and kept alive for the whole app.
@Riverpod(keepAlive: true)
LichessClient lichessClient(Ref ref) {
  final client = LichessClient(
    // Retry just once, after 500ms, on 429 Too Many Requests.
    RetryClient(
      ref.read(httpClientFactoryProvider)(),
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
String userAgent(Ref ref) {
  final session = ref.watch(authSessionProvider);

  return makeUserAgent(
    ref.read(preloadedDataProvider).requireValue.packageInfo,
    ref.read(preloadedDataProvider).requireValue.deviceInfo,
    ref.read(preloadedDataProvider).requireValue.sri,
    session?.user,
  );
}

/// Creates a user-agent string with the app version, build number, and device info and possibly the user ID if a user is logged in.
String makeUserAgent(PackageInfo info, BaseDeviceInfo deviceInfo, String sri, LightUser? user) {
  final base = 'Lichess Mobile/${info.version} as:${user?.id ?? 'anon'} sri:$sri';

  if (deviceInfo is AndroidDeviceInfo) {
    return '$base os:Android/${deviceInfo.version.release} dev:${deviceInfo.model}';
  } else if (deviceInfo is IosDeviceInfo) {
    return '$base os:iOS/${deviceInfo.systemVersion} dev:${deviceInfo.model}';
  }

  return base;
}

/// Downloads a file from the given [url] and saves it to the [file].
Future<void> downloadFile(
  Client client,
  Uri url,
  File file, {
  void Function(int received, int length)? onProgress,
}) async {
  debugPrint('Downloading $url to ${file.path}');

  final response = await client.send(Request('GET', url));
  final sink = file.openWrite();

  int received = 0;

  try {
    await response.stream
        .map((s) {
          received += s.length;
          onProgress?.call(received, response.contentLength!);
          return s;
        })
        .pipe(sink);
  } catch (e) {
    debugPrint('Failed to download file: $e');
  } finally {
    try {
      await sink.flush();
      await sink.close();
    } on FileSystemException catch (e) {
      debugPrint('Failed to save file: $e');
    }
  }
}

/// A [Client] that intercepts all requests, responses, and errors using the provided callbacks.
///
/// This client wraps around another [Client] and intercepts the requests, responses,
/// and errors, allowing custom handling through the provided callback functions.
///
/// The [onRequest] callback is called before the request is sent.
/// The [onResponse] callback is called after a response is received.
/// The [onError] callback is called when an error occurs during the request.
///
///
/// This class is intended for debugging and monitoring purposes.
///
/// See also:
/// - [BaseClient] for the base class.
/// - [Client] for the interface that this class implements.
class _RegisterCallbackClient extends BaseClient {
  _RegisterCallbackClient(this._inner, {this.onRequest, this.onResponse, this.onError});

  final Client _inner;

  final void Function(BaseRequest request)? onRequest;
  final void Function(BaseResponse response)? onResponse;
  final void Function(BaseRequest request, Object error, [StackTrace? stackTrace])? onError;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    try {
      onRequest?.call(request);
      final response = await _inner.send(request);
      onResponse?.call(response);
      return response;
    } catch (error, st) {
      onError?.call(request, error, st);
      rethrow;
    }
  }
}

/// Lichess HTTP client.
///
/// * All requests made with [head], [get], [post], [put], [patch], [delete] target
/// the lichess server, defined in [kLichessHost]. It does not apply to the low-level
/// [send] method.
/// * Sets the Authorization header when a token has been stored.
/// * Sets the user-agent header with the app version, build number, and device info. If the user is logged in, it also includes the user's id.
/// * Logs all requests and responses with status code >= 400.
/// * When a response has the 401 status, checks if the session token is still valid,
/// and deletes the session if it's not.
class LichessClient implements Client {
  LichessClient(this._inner, this._ref);

  final Ref _ref;
  final Client _inner;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final session = _ref.read(authSessionProvider);

    if (session != null && !request.headers.containsKey('Authorization')) {
      final bearer = signBearerToken(session.token);
      request.headers['Authorization'] = 'Bearer $bearer';
    }
    request.headers['User-Agent'] = makeUserAgent(
      _ref.read(preloadedDataProvider).requireValue.packageInfo,
      _ref.read(preloadedDataProvider).requireValue.deviceInfo,
      _ref.read(preloadedDataProvider).requireValue.sri,
      session?.user,
    );

    _logger.info('${request.method} ${request.url} ${request.headers['User-Agent']}');

    try {
      final response = await _inner.send(request);

      _logIfError(response);

      if (response.statusCode == 401 && session != null) {
        _checkSessionToken(session);
      }

      return response;
    } catch (e, st) {
      _logger.warning('Request to ${request.url} failed: $e', e, st);
      rethrow;
    }
  }

  /// Checks if the session token is still valid, and delete session if it's not.
  Future<void> _checkSessionToken(AuthSessionState session) async {
    final defaultClient = _ref.read(defaultClientProvider);
    final data = await defaultClient
        .postReadJson(lichessUri('/api/token/test'), mapper: (json) => json, body: session.token)
        .timeout(const Duration(seconds: 5));
    if (data[session.token] == null) {
      _logger.fine('Session is not active. Deleting it.');
      await _ref.read(authSessionProvider.notifier).delete();
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
  Future<Response> head(Uri url, {Map<String, String>? headers}) =>
      _sendUnstreamed('HEAD', url, headers);

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) =>
      _sendUnstreamed('GET', url, headers);

  @override
  Future<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) => _sendUnstreamed('POST', url, headers, body, encoding);

  @override
  Future<Response> put(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _sendUnstreamed('PUT', url, headers, body, encoding);

  @override
  Future<Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) => _sendUnstreamed('PATCH', url, headers, body, encoding);

  @override
  Future<Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) => _sendUnstreamed('DELETE', url, headers, body, encoding);

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

/// An exception thrown when the server responds with a status code >= 400.
class ServerException extends ClientException {
  final int statusCode;
  final Map<String, dynamic>? jsonError;

  ServerException(this.statusCode, super.message, Uri super.url, this.jsonError);
}

/// Throws an error if [response] is not successful.
void _checkResponseSuccess(Uri url, Response response) {
  if (response.statusCode < 400) return;
  var message = 'Request to $url failed with status ${response.statusCode}';
  if (response.reasonPhrase != null) {
    message = '$message: ${response.reasonPhrase}';
  }
  Map<String, dynamic>? jsonError;
  if (response.body.isNotEmpty) {
    try {
      final json = jsonDecode(response.body);
      if (json is Map<String, dynamic>) {
        jsonError = json;
        if (json.containsKey('error')) {
          message = '$message: ${json['error']}';
        }
      }
    } catch (e) {
      _logger.warning('Could not decode error response from $url: $e');
    }
  }
  throw ServerException(response.statusCode, '$message.', url, jsonError);
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
      _logger.severe('Could not read JSON object as $T: expected an object.');
      throw ClientException('Could not read JSON object as $T: expected an object.', url);
    }
    try {
      return mapper(json);
    } catch (e, st) {
      _logger.severe('Could not read JSON object as $T: $e', e, st);
      throw ClientException('Could not read JSON object as $T: $e\n$st', url);
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
      _logger.severe('Could not read JSON object as List: expected a list.');
      throw ClientException('Could not read JSON object as List: expected a list.', url);
    }

    final List<T> list = [];
    for (final e in json) {
      if (e is! Map<String, dynamic>) {
        _logger.severe('Could not read JSON object as $T: expected an object.');
        throw ClientException('Could not read JSON object as $T: expected an object.', url);
      }
      try {
        final mapped = mapper(e);
        if (mapped != null) {
          list.add(mapped);
        }
      } catch (e, st) {
        _logger.severe('Could not read JSON object as $T: $e', e, st);
        throw ClientException('Could not read JSON object as $T: $e', url);
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
  }) async {
    final response = await get(url, headers: headers);
    _checkResponseSuccess(url, response);
    return _readNdJsonList(response, mapper);
  }

  /// Sends an HTTP GET request with the given headers to the given URL and
  /// returns a Future that completes to the stream of the response as a ND-JSON
  /// object mapped to T.
  ///
  /// The Future will emit a [ClientException] if the response doesn't have a
  /// success status code or if an object in the response body can't be read
  /// as ND-JSON.
  Future<Stream<T>> readNdJsonStream<T>(
    Uri url, {
    Map<String, String>? headers,
    required T Function(Map<String, dynamic>) mapper,
  }) async {
    final request = Request('GET', url);
    if (headers != null) request.headers.addAll(headers);
    final response = await send(request);
    if (response.statusCode >= 400) {
      var message = 'Request to $url failed with status ${response.statusCode}';
      if (response.reasonPhrase != null) {
        message = '$message: ${response.reasonPhrase}';
      }
      throw ServerException(response.statusCode, '$message.', url, null);
    }
    try {
      return response.stream.map(utf8.decode).where((e) => e.isNotEmpty && e != '\n').map((e) {
        final json = jsonDecode(e) as Map<String, dynamic>;
        return mapper(json);
      });
    } catch (e) {
      _logger.severe('Could not read nd-json object as $T.');
      throw ClientException('Could not read nd-json object as $T: $e', url);
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
    final response = await post(url, headers: headers, body: body, encoding: encoding);
    _checkResponseSuccess(url, response);
    final json = jsonUtf8Decoder.convert(response.bodyBytes);
    if (json is! Map<String, dynamic>) {
      _logger.severe('Could not read json object as $T: expected an object.');
      throw ClientException('Could not read json object as $T: expected an object.', url);
    }
    try {
      return mapper(json);
    } catch (e, st) {
      _logger.severe('Could not read json as $T: $e', e, st);
      throw ClientException('Could not read json as $T: $e', url);
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
    final response = await post(url, headers: headers, body: body, encoding: encoding);
    _checkResponseSuccess(url, response);
    return _readNdJsonList(response, mapper);
  }

  IList<T> _readNdJsonList<T>(Response response, T Function(Map<String, dynamic>) mapper) {
    try {
      return IList(
        LineSplitter.split(
          utf8.decode(response.bodyBytes),
        ).where((e) => e.isNotEmpty && e != '\n').map((e) {
          final json = jsonDecode(e) as Map<String, dynamic>;
          return mapper(json);
        }),
      );
    } catch (e) {
      _logger.severe('Could not read nd-json objects as List<$T>.');
      throw ClientException(
        'Could not read nd-json objects as List<$T>: $e',
        response.request?.url,
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

  /// Runs [fn] with a [LichessClient] and keeps the provider alive for [duration].
  ///
  /// This is primarily used for caching network requests in a [FutureProvider].
  ///
  /// If [fn] throws with a [SocketException], the provider is not kept alive, this
  /// allows to retry the request later.
  Future<U> withClientCacheFor<U>(Future<U> Function(LichessClient) fn, Duration duration) async {
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

import 'dart:convert';
import 'dart:io';

import 'package:cupertino_http/cupertino_http.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/utils/device_info.dart';
import 'package:lichess_mobile/src/utils/package_info.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http.g.dart';

@Riverpod(keepAlive: true)
HttpClientFactory httpClientFactory(HttpClientFactoryRef ref) {
  final pInfo = ref.read(packageInfoProvider);
  final deviceInfo = ref.read(deviceInfoProvider);
  final sri = ref.read(sriProvider);
  final userAgent = makeUserAgent(pInfo, deviceInfo, sri);
  return HttpClientFactory(ref, userAgent);
}

class HttpClientFactory {
  HttpClientFactory(this._ref, this._userAgent);

  final HttpClientFactoryRef _ref;

  final String _userAgent;

  Client call() {
    return AuthClient(httpClient(_userAgent), _ref);
  }
}

const _maxCacheSize = 2 * 1024 * 1024;

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

  if (Platform.isIOS || Platform.isMacOS) {
    final config = URLSessionConfiguration.ephemeralSessionConfiguration()
      ..cache = URLCache.withCapacity(memoryCapacity: _maxCacheSize)
      ..httpAdditionalHeaders = {'User-Agent': userAgent};
    return CupertinoClient.fromSessionConfiguration(config);
  }
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

  final HttpClientFactoryRef _ref;
  final Client _inner;
  final Logger _logger = Logger('AuthClient');

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final session = _ref.read(authSessionProvider);

    if (session != null && !request.headers.containsKey('Authorization')) {
      final bearer = signBearerToken(session.token);
      request.headers['Authorization'] = 'Bearer $bearer';
      request.headers['X-User'] = session.user.id.toString();
    }

    _logger.info('${request.method} ${request.url}', request.headers);

    return _inner.send(request);
  }

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) {
    return _inner.head(url, headers: headers).then(_logIfError);
  }

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) {
    return _inner.get(url, headers: headers).then(_logIfError);
  }

  @override
  Future<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return _inner
        .post(url, headers: headers, body: body, encoding: encoding)
        .then(_logIfError);
  }

  @override
  Future<Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return _inner
        .put(url, headers: headers, body: body, encoding: encoding)
        .then(_logIfError);
  }

  @override
  Future<Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return _inner
        .patch(url, headers: headers, body: body, encoding: encoding)
        .then(_logIfError);
  }

  @override
  Future<Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return _inner
        .delete(url, headers: headers, body: body, encoding: encoding)
        .then(_logIfError);
  }

  FutureOr<Response> _logIfError(Response response) {
    if (response.request != null && response.statusCode >= 400) {
      final request = response.request!;
      final method = request.method;
      final url = request.url;
      // TODD for now logging isn't much useful
      // We could use improve it later to create an http logger in the app.
      _logger.warning(
        '$method $url responded with status ${response.statusCode}\n${response.body}',
      );
    }

    return response;
  }
}

String makeUserAgent(
  PackageInfo info,
  BaseDeviceInfo deviceInfo,
  String sri,
) {
  final base = 'Lichess Mobile/${info.version} (${info.buildNumber}) sri:$sri';

  if (deviceInfo is AndroidDeviceInfo) {
    return '$base os:Android/${deviceInfo.version.release} dev:${deviceInfo.model}';
  } else if (deviceInfo is IosDeviceInfo) {
    return '$base os:iOS/${deviceInfo.systemVersion} dev:${deviceInfo.model}';
  }

  return base;
}

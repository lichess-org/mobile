import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:async/async.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:lichess_mobile/src/common/errors.dart';
import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/constants.dart';

const redirectUri = 'org.lichess.mobile://login-callback';
const oauthScopes = ['board:play'];

class AuthRepository {
  AuthRepository(
    ApiClient apiClient,
    FlutterAppAuth appAuth,
    FlutterSecureStorage storage,
    Logger log,
  )   : _apiClient = apiClient,
        _appAuth = appAuth,
        _storage = storage,
        _log = log;

  final ApiClient _apiClient;
  final Logger _log;
  final FlutterAppAuth _appAuth;
  final FlutterSecureStorage _storage;

  FutureResult<void> signIn() {
    final future = (() async {
      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          kLichessClientId,
          redirectUri,
          allowInsecureConnections: kDebugMode,
          serviceConfiguration: const AuthorizationServiceConfiguration(
            authorizationEndpoint: '$kLichessHost/oauth',
            tokenEndpoint: '$kLichessHost/api/token',
          ),
          scopes: oauthScopes,
        ),
      );
      if (result != null) {
        _log.fine('Got accessToken ${result.accessToken}');
        await _storage.write(
          key: kOAuthTokenStorageKey,
          value: result.accessToken,
        );
      } else {
        throw Exception('FlutterAppAuth.authorizeAndExchangeCode null result');
      }
    })();

    return Result.capture(future).mapError((error, trace) {
      _log.severe('signIn error', error, trace);
      return ApiRequestException();
    });
  }

  FutureResult<void> signOut() {
    return _apiClient.delete(Uri.parse('$kLichessHost/api/token')).then(
          (result) => result.map((_) async {
            await _storage.delete(key: kOAuthTokenStorageKey);
          }),
        );
  }
}

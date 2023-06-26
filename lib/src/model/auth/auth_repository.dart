import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:async/async.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

import 'package:lichess_mobile/src/model/common/errors.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/constants.dart';

part 'auth_repository.g.dart';

const redirectUri = 'org.lichess.mobile://login-callback';
const oauthScopes = ['web:mobile'];

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  const auth = FlutterAppAuth();
  return AuthRepository(
    ref.watch(authClientProvider),
    auth,
    Logger('AuthRepository'),
  );
}

class AuthRepository {
  AuthRepository(
    AuthClient apiClient,
    FlutterAppAuth appAuth,
    Logger log,
  )   : _apiClient = apiClient,
        _appAuth = appAuth,
        _log = log;

  final AuthClient _apiClient;
  final Logger _log;
  final FlutterAppAuth _appAuth;

  FutureResult<AuthorizationTokenResponse> signIn() {
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
        _log.fine('Got oAuth response $result');
        return result;
      } else {
        throw Exception(
          'FlutterAppAuth.authorizeAndExchangeCode failed to get token',
        );
      }
    })();

    return Result.capture(future).mapError((error, trace) {
      _log.severe('signIn error', error, trace);
      return const ApiRequestException(500, 'Failed to get access token.');
    });
  }

  FutureResult<void> signOut() {
    return _apiClient.delete(Uri.parse('$kLichessHost/api/token'));
  }
}

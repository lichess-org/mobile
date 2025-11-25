import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:logging/logging.dart';

const redirectUri = 'org.lichess.mobile://login-callback';
const oauthScopes = ['web:mobile'];

/// A provider for [FlutterAppAuth].
final appAuthProvider = Provider<FlutterAppAuth>((Ref ref) {
  return const FlutterAppAuth();
}, name: 'AppAuthProvider');

final authRepositoryProvider = Provider<AuthRepository>((Ref ref) {
  final appAuth = ref.read(appAuthProvider);
  return AuthRepository(ref, appAuth);
}, name: 'AuthRepositoryProvider');

class AuthRepository {
  AuthRepository(Ref ref, FlutterAppAuth appAuth) : _ref = ref, _appAuth = appAuth;

  final Ref _ref;
  final Logger _log = Logger('AuthRepository');
  final FlutterAppAuth _appAuth;

  LichessClient get _client => _ref.read(lichessClientProvider);

  /// Sign in with Lichess.
  ///
  /// This method uses the [FlutterAppAuth] package to sign in with Lichess using
  /// OAuth 2.0. It first calls [FlutterAppAuth.authorizeAndExchangeCode] to
  /// get an access token, and then calls the Lichess API to get the user's
  /// account information.
  Future<AuthUser> signIn() async {
    final authResp = await _appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        kLichessClientId,
        redirectUri,
        allowInsecureConnections: kDebugMode,
        serviceConfiguration: AuthorizationServiceConfiguration(
          authorizationEndpoint: lichessUri('/oauth').toString(),
          tokenEndpoint: lichessUri('/api/token').toString(),
        ),
        scopes: oauthScopes,
      ),
    );

    _log.fine('Got oAuth response $authResp');

    final token = authResp.accessToken;

    if (token == null) {
      throw Exception('Access token not found.');
    }

    final user = await _client.readJson(
      Uri(path: '/api/account'),
      headers: {'Authorization': 'Bearer ${signBearerToken(token)}'},
      mapper: User.fromServerJson,
    );
    return AuthUser(token: token, user: user.lightUser);
  }

  /// Sign out the current user by revoking the authUser token.
  Future<void> signOut() async {
    await _client.deleteRead(Uri(path: '/api/token'));
  }

  /// Check if the given authUser token is valid.
  Future<bool> checkToken(AuthUser authUser) async {
    final defaultClient = _ref.read(defaultClientProvider);
    final data = await defaultClient
        .postReadJson(lichessUri('/api/token/test'), mapper: (json) => json, body: authUser.token)
        .timeout(const Duration(seconds: 5));
    return data[authUser.token] != null;
  }
}

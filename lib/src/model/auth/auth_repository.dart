import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

const redirectUri = 'org.lichess.mobile://login-callback';
const oauthScopes = ['web:mobile'];

@Riverpod(keepAlive: true)
FlutterAppAuth appAuth(Ref ref) {
  return const FlutterAppAuth();
}

class AuthRepository {
  AuthRepository(LichessClient client, FlutterAppAuth appAuth)
    : _client = client,
      _appAuth = appAuth;

  final LichessClient _client;
  final Logger _log = Logger('AuthRepository');
  final FlutterAppAuth _appAuth;

  /// Sign in with Lichess.
  ///
  /// This method uses the [FlutterAppAuth] package to sign in with Lichess using
  /// OAuth 2.0. It first calls [FlutterAppAuth.authorizeAndExchangeCode] to
  /// get an access token, and then calls the Lichess API to get the user's
  /// account information.
  Future<AuthSessionState> signIn() async {
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
    return AuthSessionState(token: token, user: user.lightUser);
  }

  Future<void> signOut() async {
    final url = Uri(path: '/api/token');
    final response = await _client.delete(Uri(path: '/api/token'));
    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to delete token: ${response.statusCode}', url);
    }
  }
}

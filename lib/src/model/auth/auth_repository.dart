import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/constants.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

const redirectUri = 'org.lichess.mobile://login-callback';
const oauthScopes = ['web:mobile'];

@Riverpod(keepAlive: true)
FlutterAppAuth appAuth(AppAuthRef ref) {
  return const FlutterAppAuth();
}

class AuthRepository {
  AuthRepository(
    http.Client client,
    FlutterAppAuth appAuth,
  )   : _client = client,
        _appAuth = appAuth;

  final http.Client _client;
  final Logger _log = Logger('AuthRepository');
  final FlutterAppAuth _appAuth;

  Future<AuthorizationTokenResponse> signIn() async {
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
  }

  Future<void> signOut() {
    return _client.delete(Uri.parse('$kLichessHost/api/token'));
  }
}

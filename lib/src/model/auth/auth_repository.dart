import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/json.dart';
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

  Future<AuthSessionState> signIn() async {
    final authResp = await _appAuth.authorizeAndExchangeCode(
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

    if (authResp == null) {
      throw Exception(
        'FlutterAppAuth.authorizeAndExchangeCode failed to get token',
      );
    }

    _log.fine('Got oAuth response $authResp');

    final token = authResp.accessToken;

    if (token == null) {
      throw Exception('Access token not found.');
    }

    return _client.readBytes(
      Uri.parse('$kLichessHost/api/account'),
      headers: {
        'Authorization': 'Bearer ${signBearerToken(token)}',
      },
    ).then((bytes) {
      final user = readJsonObjectFromBytes(
        bytes,
        mapper: User.fromServerJson,
      );
      return AuthSessionState(
        token: token,
        user: user.lightUser,
      );
    });
  }

  Future<void> signOut() {
    return _client.delete(Uri.parse('$kLichessHost/api/token'));
  }
}

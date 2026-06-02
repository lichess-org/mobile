import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:logging/logging.dart';

const kLichessUriScheme = 'org.lichess.mobile';
const kOAuthRedirectUriHost = 'login-callback';
const kOAuthRedirectUri = '$kLichessUriScheme://$kOAuthRedirectUriHost';
const oauthScopes = ['web:mobile'];

/// Host the app claims via verified Android App Links / iOS Universal Links. The HTTPS OAuth
/// callback is only valid on this host; against any other host (dev/staging) the custom URI scheme
/// is used instead.
const _appLinkVerifiedHost = 'lichess.org';

/// Path of the HTTPS OAuth redirect/callback. Must stay in sync with:
///  - the redirect URI registered for the `lichess_mobile` client on the lichess server,
///  - the App Link intent-filter in `android/app/src/main/AndroidManifest.xml`,
///  - the `apple-app-site-association` entry served by lichess.org.
const kOAuthHttpsCallbackPath = '/account/oauth/mobile-callback';
const _oauthHttpsRedirectUri = 'https://$_appLinkVerifiedHost$kOAuthHttpsCallbackPath';

/// Whether to use the HTTPS App Link OAuth callback on Android.
///
/// The HTTPS `redirect_uri` is rejected by lichess until the server registers it for the
/// `lichess_mobile` client. Keep this disabled so Android keeps using the custom-scheme callback
/// (which lichess already accepts), and flip it to `true` in lockstep with the server-side deploy
/// that accepts the HTTPS redirect URI.
const kEnableHttpsOAuthCallback = false;

final authRepositoryProvider = Provider<AuthRepository>((Ref ref) {
  return AuthRepository(ref);
}, name: 'AuthRepositoryProvider');

class AuthRepository {
  AuthRepository(Ref ref) : _ref = ref;

  final Ref _ref;
  final Logger _log = Logger('AuthRepository');
  final _random = Random.secure();

  LichessClient get _client => _ref.read(lichessClientProvider);

  /// Sign in with Lichess using OAuth 2.0 PKCE.
  ///
  /// Opens a system auth session (Chrome Auth/Custom Tab on Android,
  /// `ASWebAuthenticationSession` on iOS) to the Lichess authorization page and waits for the
  /// redirect back to the app.
  Future<AuthUser> signIn() async {
    final codeVerifier = _generateCodeVerifier();
    final codeChallenge = _generateCodeChallenge(codeVerifier);
    final state = _generateState();

    // Pick the OAuth callback transport. HTTPS App Links are only verified for
    // [_appLinkVerifiedHost] and are used on Android, where Chrome unreliably hands off the
    // custom-scheme redirect. iOS — where ASWebAuthenticationSession captures the custom scheme
    // directly — and all dev/staging hosts keep the custom URI scheme.
    final useHttpsCallback =
        kEnableHttpsOAuthCallback &&
        defaultTargetPlatform == TargetPlatform.android &&
        kLichessHost == _appLinkVerifiedHost;
    final redirectUri = useHttpsCallback ? _oauthHttpsRedirectUri : kOAuthRedirectUri;
    final callbackUrlScheme = useHttpsCallback ? 'https' : kLichessUriScheme;

    final authUrl = lichessUri('/oauth', {
      'response_type': 'code',
      'client_id': kLichessClientId,
      'redirect_uri': redirectUri,
      'scope': oauthScopes.join(' '),
      'code_challenge': codeChallenge,
      'code_challenge_method': 'S256',
      'state': state,
    });

    final String callbackUrl;
    try {
      callbackUrl = await FlutterWebAuth2.authenticate(
        url: authUrl.toString(),
        callbackUrlScheme: callbackUrlScheme,
        options: FlutterWebAuth2Options(
          httpsHost: useHttpsCallback ? _appLinkVerifiedHost : null,
          httpsPath: useHttpsCallback ? kOAuthHttpsCallbackPath : null,
        ),
      );
    } on PlatformException catch (e) {
      // The user dismissed the auth session before completing it.
      if (e.code == 'CANCELED') {
        throw Exception('Sign-in was cancelled.');
      }
      rethrow;
    }

    final callbackUri = Uri.parse(callbackUrl);

    if (callbackUri.queryParameters['state'] != state) {
      throw Exception('OAuth state mismatch.');
    }

    final error = callbackUri.queryParameters['error'];
    if (error != null) {
      final errorDescription = callbackUri.queryParameters['error_description'];
      final message = errorDescription != null
          ? 'OAuth error: $error - $errorDescription'
          : 'OAuth error: $error';
      throw Exception(message);
    }

    final code = callbackUri.queryParameters['code'];
    if (code == null) {
      throw Exception('Authorization code not found.');
    }

    final tokenResponse = await _client.postReadJson(
      Uri(path: '/api/token'),
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'code_verifier': codeVerifier,
        'redirect_uri': redirectUri,
        'client_id': kLichessClientId,
      },
      mapper: (json) => json,
    );

    _log.fine('Got OAuth token response');

    final token = tokenResponse['access_token'] as String?;
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

  /// Sign out the current user by revoking the auth token.
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

  String _generateCodeVerifier() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    return List.generate(64, (_) => chars[_random.nextInt(chars.length)]).join();
  }

  String _generateCodeChallenge(String codeVerifier) {
    final digest = sha256.convert(utf8.encode(codeVerifier));
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }

  String _generateState() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }
}

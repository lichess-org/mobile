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

/// Host of the custom URI scheme callback. Must stay in sync with the callback activity intent-filter in `android/app/src/main/AndroidManifest.xml`.
const _kOAuthCustomSchemeCallbackHost = 'login-callback';

/// The custom URI scheme redirect for OAuth. Used on iOS and for dev/staging hosts where App Links aren't verified.
const kOAuthCustomSchemeRedirectUri =
    '$kLichessCustomUriSchemeName://$_kOAuthCustomSchemeCallbackHost';
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

/// Thrown when the user dismisses the OAuth session before completing it.
///
/// This is distinct from a genuine sign-in failure: the UI should silently
/// ignore it rather than surfacing an error.
class SignInCancelledException implements Exception {
  const SignInCancelledException();

  @override
  String toString() => 'Sign-in was cancelled.';
}

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
        defaultTargetPlatform == TargetPlatform.android && kLichessHost == _appLinkVerifiedHost;
    final redirectUri = useHttpsCallback ? _oauthHttpsRedirectUri : kOAuthCustomSchemeRedirectUri;
    final callbackUrlScheme = useHttpsCallback ? 'https' : kLichessCustomUriSchemeName;

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
        throw const SignInCancelledException();
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

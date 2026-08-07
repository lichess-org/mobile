import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_user.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';
import 'package:lichess_mobile/src/model/auth/sign_in_failure_reporter.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:logging/logging.dart';

/// Host of the custom URI scheme callback. Must stay in sync with the
/// intent-filter for `net.openid.appauth.RedirectUriReceiverActivity` in
/// `android/app/src/main/AndroidManifest.xml` and the `CFBundleURLSchemes` entry in `ios/Runner/Info.plist`.
const _kOAuthCustomSchemeCallbackHost = 'login-callback';

/// The custom URI scheme redirect for OAuth.
///
/// Custom schemes are more universally supported across Android browsers/OEMs than
/// HTTPS App Link redirects, so they are used on every platform and host.
const kOAuthRedirectUri = '$kLichessCustomUriSchemeName://$_kOAuthCustomSchemeCallbackHost';
const oauthScopes = ['web:mobile'];

/// Thrown when the user dismisses the OAuth session before completing it.
///
/// This is distinct from a genuine sign-in failure: the UI should silently
/// ignore it rather than surfacing an error.
class SignInCancelledException implements Exception {
  const SignInCancelledException();

  @override
  String toString() => 'Sign-in was cancelled.';
}

/// Thrown when the server rate-limits one of the email login requests (429).
class EmailLoginRateLimitException implements Exception {
  const EmailLoginRateLimitException();

  @override
  String toString() => 'Too many email login requests.';
}

/// Thrown when the submitted login code is unknown, expired, or already used (404).
class InvalidEmailLoginCodeException implements Exception {
  const InvalidEmailLoginCodeException();

  @override
  String toString() => 'Invalid or expired email login code.';
}

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

  /// Sign in with Lichess using OAuth 2.0 PKCE using the system browser.
  Future<AuthUser> signIn() async {
    final AuthorizationTokenResponse authResp;
    try {
      authResp = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          kLichessClientId,
          kOAuthRedirectUri,
          allowInsecureConnections: kDebugMode,
          serviceConfiguration: AuthorizationServiceConfiguration(
            authorizationEndpoint: lichessUri('/oauth').toString(),
            tokenEndpoint: lichessUri('/api/token').toString(),
          ),
          scopes: oauthScopes,
        ),
      );
    } on FlutterAppAuthUserCancelledException {
      throw const SignInCancelledException();
    } catch (e, st) {
      await reportSignInFailure(_ref, e, st);
      rethrow;
    }

    _log.fine('Got OAuth token response');

    final token = authResp.accessToken;
    if (token == null) {
      throw Exception('Access token not found.');
    }

    return _fetchAuthUser(token);
  }

  /// Asks lichess to email a 6 character login code to [email].
  ///
  /// Throws an [EmailLoginRateLimitException] if the request is rate-limited.
  Future<void> requestEmailLoginCode(String email) async {
    final url = lichessUri('/auth/mobile-code/email', {'email': email});
    // The default client is used on purpose: this endpoint is unauthenticated, and its 429 responses
    // are deliberate rate limiting that must not be retried like [lichessClientProvider] does.
    final response = await _ref.read(defaultClientProvider).post(url);

    if (response.statusCode == 429) {
      throw const EmailLoginRateLimitException();
    }
    if (response.statusCode >= 400) {
      throw ServerException(
        response.statusCode,
        'Could not request an email login code: ${response.statusCode}',
        url,
        null,
      );
    }
  }

  /// Exchanges the login [code] received by [email] for an OAuth token, and fetches the account it
  /// belongs to.
  ///
  /// Throws an [InvalidEmailLoginCodeException] if the code is unknown, expired, or already used,
  /// and an [EmailLoginRateLimitException] if the request is rate-limited.
  Future<AuthUser> signInWithEmailCode({required String email, required String code}) async {
    final url = lichessUri('/auth/mobile-code/bearer', {'email': email, 'code': code});
    final response = await _ref.read(defaultClientProvider).post(url);

    switch (response.statusCode) {
      case 429:
        throw const EmailLoginRateLimitException();
      case 404:
        throw const InvalidEmailLoginCodeException();
    }
    if (response.statusCode >= 400) {
      throw ServerException(
        response.statusCode,
        'Could not exchange the email login code: ${response.statusCode}',
        url,
        null,
      );
    }

    final token = response.body.trim();
    if (token.isEmpty) {
      throw Exception('Access token not found.');
    }

    _log.fine('Got a token from the email login code');

    return _fetchAuthUser(token);
  }

  /// Fetches the account owning [token] and pairs it with the token.
  Future<AuthUser> _fetchAuthUser(String token) async {
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
}

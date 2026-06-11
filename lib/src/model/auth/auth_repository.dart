import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
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

  /// Sign in with Lichess using OAuth 2.0 PKCE.
  ///
  /// This method uses the [FlutterAppAuth] package to perform the authorization
  /// code flow with PKCE: it opens the system browser (Custom Tab on Android,
  /// `ASWebAuthenticationSession` on iOS) to the Lichess authorization page, waits
  /// for the redirect back to the app via the custom URI scheme, exchanges the
  /// authorization code for an access token, and then fetches the user's account.
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
    } on FlutterAppAuthUserCancelledException catch (e, st) {
      // The user dismissed the auth session before completing it. This is also how broken-redirect
      // failures surface (see [reportSignInFailure]), so it is still recorded for monitoring.
      await reportSignInFailure(_ref, e, st, cancelled: true);
      throw const SignInCancelledException();
    } catch (e, st) {
      await reportSignInFailure(_ref, e, st, cancelled: false);
      rethrow;
    }

    _log.fine('Got OAuth token response');

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

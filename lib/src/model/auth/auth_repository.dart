import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';
import 'package:lichess_mobile/src/model/auth/oauth_callback.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

const kOAuthRedirectUriScheme = 'org.lichess.mobile';
const kOAuthRedirectUriHost = 'login-callback';
const kOAuthRedirectUri = '$kOAuthRedirectUriScheme://$kOAuthRedirectUriHost';
const oauthScopes = ['web:mobile'];

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
  /// Opens an in-app browser (or fallback to the system default browser) to the Lichess
  /// authorization page.
  /// After the user authorizes, the browser redirects to [kOAuthRedirectUri] which
  /// is caught by the app links handler and forwarded to [oauthCallbackProvider].
  Future<AuthUser> signIn() async {
    final codeVerifier = _generateCodeVerifier();
    final codeChallenge = _generateCodeChallenge(codeVerifier);
    final state = _generateState();

    final authUrl = lichessUri('/oauth').replace(
      queryParameters: {
        'response_type': 'code',
        'client_id': kLichessClientId,
        'redirect_uri': kOAuthRedirectUri,
        'scope': oauthScopes.join(' '),
        'code_challenge': codeChallenge,
        'code_challenge_method': 'S256',
        'state': state,
      },
    );

    final launched = await launchUrl(authUrl, mode: .inAppBrowserView);
    if (!launched) {
      throw Exception('Could not open browser for authentication.');
    }

    final callbackCompleter = Completer<Uri>();

    // Listen for the redirect callback URI from the browser.
    // Mismatched URIs (stale callbacks, unrelated deep links) are silently ignored and the listener
    // keeps waiting.
    final callbackSub = _ref
        .read(oauthCallbackProvider)
        .stream
        .listen(
          (uri) {
            if (!callbackCompleter.isCompleted &&
                uri.scheme == kOAuthRedirectUriScheme &&
                uri.host == kOAuthRedirectUriHost &&
                uri.queryParameters['state'] == state) {
              callbackCompleter.complete(uri);
            }
          },
          onError: (Object error) {
            if (!callbackCompleter.isCompleted) {
              callbackCompleter.completeError(error);
            }
          },
        );

    // Cancel the flow when the user dismisses the browser without completing auth. When a redirect
    // succeeds, the callback URI arrives in Dart before (or very shortly after) the resumed
    // lifecycle event — a short delay prevents a false cancellation in the success path.
    final lifecycleListener = AppLifecycleListener(
      onResume: () => Future<void>.delayed(const Duration(milliseconds: 300), () {
        if (!callbackCompleter.isCompleted) {
          callbackCompleter.completeError(Exception('Sign-in was cancelled.'));
        }
      }),
    );

    final Uri callbackUri;
    try {
      callbackUri = await callbackCompleter.future.timeout(const Duration(minutes: 5));
    } finally {
      // Dismiss the in-app browser in all cases (no-op if already closed).
      unawaited(closeInAppWebView());
      unawaited(callbackSub.cancel());
      lifecycleListener.dispose();
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
        'redirect_uri': kOAuthRedirectUri,
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

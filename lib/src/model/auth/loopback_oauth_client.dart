import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

/// Standard Lichess API scopes requested during loopback desktop sign-in.
///
/// Note: Lichess's server restricts the mobile-only scope (`web:mobile`) strictly to the
/// `org.lichess.mobile://` origin. On loopback interface redirects (`http://127.0.0.1:<port>/`),
/// standard Lichess API scopes are used instead.
const kLoopbackOAuthScopes = [
  'email:read',
  'preference:read',
  'preference:write',
  'challenge:read',
  'challenge:write',
  'study:read',
  'study:write',
  'tournament:read',
  'tournament:write',
  'racer:write',
  'puzzle:read',
  'puzzle:write',
  'team:read',
  'team:write',
  'follow:read',
  'follow:write',
  'msg:write',
  'board:play',
];

/// Result of a successful loopback authorization code acquisition.
class LoopbackAuthResult {
  const LoopbackAuthResult({
    required this.code,
    required this.codeVerifier,
    required this.redirectUri,
  });

  final String code;
  final String codeVerifier;
  final String redirectUri;
}

typedef UrlLauncherFn = Future<bool> Function(Uri url, {LaunchMode mode});

final loopbackOAuthClientProvider = Provider<LoopbackOAuthClient>((Ref ref) {
  return const LoopbackOAuthClient();
}, name: 'LoopbackOAuthClientProvider');

/// Performs OAuth 2.0 PKCE authorization via a local loopback HTTP server (RFC 8252).
class LoopbackOAuthClient {
  const LoopbackOAuthClient({UrlLauncherFn? urlLauncher}) : _urlLauncher = urlLauncher ?? launchUrl;

  final UrlLauncherFn _urlLauncher;
  static final Logger _log = Logger('LoopbackOAuthClient');

  /// Binds an ephemeral loopback HTTP server, opens the system browser to the Lichess OAuth
  /// endpoint with PKCE parameters, awaits the callback, and returns the authorization code.
  Future<LoopbackAuthResult> acquireAuthorizationCode({
    required String clientId,
    required List<String> scopes,
    Duration timeout = const Duration(minutes: 5),
  }) async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final port = server.port;
    final redirectUri = 'http://127.0.0.1:$port/';

    final codeVerifier = _generateCodeVerifier();
    final codeChallenge = _generateCodeChallenge(codeVerifier);
    final state = _generateState();

    final authUri = lichessUri('/oauth', {
      'response_type': 'code',
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'scope': scopes.join(' '),
      'code_challenge': codeChallenge,
      'code_challenge_method': 'S256',
      'state': state,
    });

    final codeCompleter = Completer<String>();
    // Pre-register an error listener so that completing with an error while _urlLauncher is
    // being awaited does not trigger an unhandled asynchronous error in the current Zone.
    codeCompleter.future.ignore();
    StreamSubscription<HttpRequest>? sub;

    sub = server.listen(
      (HttpRequest request) async {
        try {
          // Only respond to GET requests at the root path.
          if (request.method != 'GET' || request.uri.path != '/') {
            request.response
              ..statusCode = HttpStatus.notFound
              ..write('Not found');
            await request.response.close();
            return;
          }

          final queryParams = request.uri.queryParameters;
          final error = queryParams['error'];
          final returnedState = queryParams['state'];
          final code = queryParams['code'];

          // Guard against stale tabs or probes with mismatching state; keep listening.
          if (returnedState != state) {
            _log.warning('Ignoring callback request with mismatching state');
            request.response
              ..statusCode = HttpStatus.badRequest
              ..headers.contentType = ContentType.html
              ..write('<!DOCTYPE html><html><body><h3>Invalid state parameter.</h3></body></html>');
            await request.response.close();
            return;
          }

          if (error != null) {
            final errorDesc = queryParams['error_description'] ?? error;
            request.response
              ..statusCode = HttpStatus.ok
              ..headers.contentType = ContentType.html
              ..write(_buildErrorHtml(errorDesc));
            await request.response.close();

            if (!codeCompleter.isCompleted) {
              if (error == 'access_denied') {
                codeCompleter.completeError(const SignInCancelledException());
              } else {
                codeCompleter.completeError(Exception('OAuth error: $errorDesc'));
              }
            }
            return;
          }

          if (code == null || code.isEmpty) {
            request.response
              ..statusCode = HttpStatus.badRequest
              ..headers.contentType = ContentType.html
              ..write(
                '<!DOCTYPE html><html><body><h3>Missing authorization code.</h3></body></html>',
              );
            await request.response.close();
            return;
          }

          request.response
            ..statusCode = HttpStatus.ok
            ..headers.contentType = ContentType.html
            ..write(_buildSuccessHtml());
          await request.response.close();

          if (!codeCompleter.isCompleted) {
            codeCompleter.complete(code);
          }
        } catch (e, st) {
          _log.warning('Error handling loopback HTTP request', e, st);
        }
      },
      onError: (Object error, StackTrace st) {
        _log.warning('Loopback server stream error', error, st);
        if (!codeCompleter.isCompleted) {
          codeCompleter.completeError(error, st);
        }
      },
    );

    try {
      final launched = await _urlLauncher(authUri, mode: LaunchMode.externalApplication);
      if (!launched) {
        throw Exception('Could not launch system browser for authentication.');
      }

      final String code;
      try {
        code = await codeCompleter.future.timeout(timeout);
      } on TimeoutException {
        throw const SignInCancelledException();
      }

      return LoopbackAuthResult(code: code, codeVerifier: codeVerifier, redirectUri: redirectUri);
    } finally {
      await sub.cancel();
      await server.close(force: true);
    }
  }

  static String _buildSuccessHtml() {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Lichess Sign-in Successful</title>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
      background: #161512;
      color: #bababa;
    }
    div {
      text-align: center;
      padding: 2rem;
      background: #262421;
      border-radius: 8px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.5);
    }
    h1 {
      color: #629924;
      margin-bottom: 0.5rem;
    }
  </style>
</head>
<body>
  <div>
    <h1>Authentication Successful!</h1>
    <p>You can close this tab and return to the Lichess app.</p>
  </div>
</body>
</html>''';
  }

  static String _buildErrorHtml(String rawErrorDescription) {
    final sanitizedError = htmlEscape.convert(rawErrorDescription);
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Sign-in Failed</title>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      text-align: center;
      padding: 40px;
      background: #161512;
      color: #bababa;
    }
    h2 {
      color: #cc3333;
    }
  </style>
</head>
<body>
  <h2>Sign-in cancelled or failed</h2>
  <p>$sanitizedError</p>
  <p>You can close this tab.</p>
</body>
</html>''';
  }

  static String _generateCodeVerifier() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  static String _generateCodeChallenge(String verifier) {
    final bytes = ascii.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }

  static String _generateState() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/model/auth/loopback_oauth_client.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  group('LoopbackOAuthClient', () {
    final originalHttpOverrides = HttpOverrides.current;

    setUp(() {
      HttpOverrides.global = null;
    });

    tearDown(() {
      HttpOverrides.global = originalHttpOverrides;
    });

    test('successfully acquires authorization code via loopback callback', () async {
      late Uri capturedAuthUri;
      final client = LoopbackOAuthClient(
        urlLauncher: (Uri url, {LaunchMode mode = LaunchMode.platformDefault}) async {
          capturedAuthUri = url;
          final state = url.queryParameters['state']!;
          final redirectUri = Uri.parse(url.queryParameters['redirect_uri']!);

          final callbackUri = redirectUri.replace(
            queryParameters: {'code': 'test_auth_code_123', 'state': state},
          );
          final response = await http.get(callbackUri);
          expect(response.statusCode, HttpStatus.ok);
          expect(response.body, contains('Authentication Successful!'));
          return true;
        },
      );

      final result = await client.acquireAuthorizationCode(
        clientId: 'test-client',
        scopes: ['email:read', 'board:play'],
      );

      expect(result.code, 'test_auth_code_123');
      expect(result.codeVerifier.isNotEmpty, true);
      expect(result.redirectUri, startsWith('http://127.0.0.1:'));
      expect(capturedAuthUri.path, '/oauth');
      expect(capturedAuthUri.queryParameters['client_id'], 'test-client');
      expect(capturedAuthUri.queryParameters['scope'], 'email:read board:play');
      expect(capturedAuthUri.queryParameters['code_challenge_method'], 'S256');
    });

    test('ignores state mismatch and continues listening for valid callback', () async {
      final client = LoopbackOAuthClient(
        urlLauncher: (Uri url, {LaunchMode mode = LaunchMode.platformDefault}) async {
          final state = url.queryParameters['state']!;
          final redirectUri = Uri.parse(url.queryParameters['redirect_uri']!);

          // Send mismatching request first (e.g. stale browser tab or probe)
          final invalidUri = redirectUri.replace(
            queryParameters: {'code': 'bad_code', 'state': 'wrong_state'},
          );
          final invalidResp = await http.get(invalidUri);
          expect(invalidResp.statusCode, HttpStatus.badRequest);
          expect(invalidResp.body, contains('Invalid state parameter'));

          // Send valid request
          final validUri = redirectUri.replace(
            queryParameters: {'code': 'valid_code', 'state': state},
          );
          final validResp = await http.get(validUri);
          expect(validResp.statusCode, HttpStatus.ok);
          expect(validResp.body, contains('Authentication Successful!'));
          return true;
        },
      );

      final result = await client.acquireAuthorizationCode(
        clientId: 'test-client',
        scopes: ['email:read'],
      );

      expect(result.code, 'valid_code');
    });

    test('returns 404 for non-GET or non-root paths and continues listening', () async {
      final client = LoopbackOAuthClient(
        urlLauncher: (Uri url, {LaunchMode mode = LaunchMode.platformDefault}) async {
          final state = url.queryParameters['state']!;
          final redirectUri = Uri.parse(url.queryParameters['redirect_uri']!);

          // Send request to /favicon.ico
          final faviconUri = redirectUri.replace(path: '/favicon.ico');
          final faviconResp = await http.get(faviconUri);
          expect(faviconResp.statusCode, HttpStatus.notFound);

          // Now send valid callback
          final validUri = redirectUri.replace(
            queryParameters: {'code': 'valid_code', 'state': state},
          );
          final validResp = await http.get(validUri);
          expect(validResp.statusCode, HttpStatus.ok);
          return true;
        },
      );

      final result = await client.acquireAuthorizationCode(
        clientId: 'test-client',
        scopes: ['email:read'],
      );

      expect(result.code, 'valid_code');
    });

    test('throws SignInCancelledException on access_denied error', () async {
      final client = LoopbackOAuthClient(
        urlLauncher: (Uri url, {LaunchMode mode = LaunchMode.platformDefault}) async {
          final state = url.queryParameters['state']!;
          final redirectUri = Uri.parse(url.queryParameters['redirect_uri']!);

          final callbackUri = redirectUri.replace(
            queryParameters: {'error': 'access_denied', 'state': state},
          );
          final response = await http.get(callbackUri);
          expect(response.statusCode, HttpStatus.ok);
          expect(response.body, contains('Sign-in cancelled or failed'));
          return true;
        },
      );

      await expectLater(
        client.acquireAuthorizationCode(clientId: 'test-client', scopes: ['email:read']),
        throwsA(isA<SignInCancelledException>()),
      );
    });

    test('throws Exception on non-access_denied OAuth error and sanitizes output', () async {
      final client = LoopbackOAuthClient(
        urlLauncher: (Uri url, {LaunchMode mode = LaunchMode.platformDefault}) async {
          final state = url.queryParameters['state']!;
          final redirectUri = Uri.parse(url.queryParameters['redirect_uri']!);

          final callbackUri = redirectUri.replace(
            queryParameters: {
              'error': 'invalid_scope',
              'error_description': '<script>alert(1)</script>',
              'state': state,
            },
          );
          final response = await http.get(callbackUri);
          expect(response.statusCode, HttpStatus.ok);
          expect(response.body, contains(htmlEscape.convert('<script>alert(1)</script>')));
          expect(response.body, isNot(contains('<script>alert(1)</script>')));
          return true;
        },
      );

      await expectLater(
        client.acquireAuthorizationCode(clientId: 'test-client', scopes: ['email:read']),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('OAuth error: <script>alert(1)</script>'),
          ),
        ),
      );
    });

    test('returns 400 when callback is missing code and error', () async {
      final client = LoopbackOAuthClient(
        urlLauncher: (Uri url, {LaunchMode mode = LaunchMode.platformDefault}) async {
          final state = url.queryParameters['state']!;
          final redirectUri = Uri.parse(url.queryParameters['redirect_uri']!);

          final emptyUri = redirectUri.replace(queryParameters: {'state': state});
          final response = await http.get(emptyUri);
          expect(response.statusCode, HttpStatus.badRequest);
          expect(response.body, contains('Missing authorization code.'));

          // Follow up with valid callback
          final validUri = redirectUri.replace(
            queryParameters: {'code': 'code_after_empty', 'state': state},
          );
          await http.get(validUri);
          return true;
        },
      );

      final result = await client.acquireAuthorizationCode(
        clientId: 'test-client',
        scopes: ['email:read'],
      );

      expect(result.code, 'code_after_empty');
    });

    test('throws Exception when url launcher returns false', () async {
      final client = LoopbackOAuthClient(
        urlLauncher: (Uri url, {LaunchMode mode = LaunchMode.platformDefault}) async => false,
      );

      await expectLater(
        client.acquireAuthorizationCode(clientId: 'test-client', scopes: ['email:read']),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Could not launch system browser for authentication.'),
          ),
        ),
      );
    });

    test('throws SignInCancelledException when timeout expires', () async {
      final client = LoopbackOAuthClient(
        urlLauncher: (Uri url, {LaunchMode mode = LaunchMode.platformDefault}) async => true,
      );

      await expectLater(
        client.acquireAuthorizationCode(
          clientId: 'test-client',
          scopes: ['email:read'],
          timeout: const Duration(milliseconds: 50),
        ),
        throwsA(isA<SignInCancelledException>()),
      );
    });
  });
}

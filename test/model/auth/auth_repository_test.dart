import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_auth_2_platform_interface/flutter_web_auth_2_platform_interface.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';

import '../../test_container.dart';
import '../../test_helpers.dart';

const _tokenResponse = '{"access_token": "test-token"}';
const _accountResponse =
    '{"id":"test","username":"test","createdAt":1290415680000,"seenAt":1290415680000,"perfs":{}}';

/// Fake [FlutterWebAuth2Platform] that returns a canned callback URL (or throws) instead of opening
/// a real browser session. The handler receives the authorization URL so it can echo back the
/// `state` parameter, exactly as a real redirect would.
class FakeFlutterWebAuth2 extends FlutterWebAuth2Platform {
  FakeFlutterWebAuth2(this.onAuthenticate);

  final Future<String> Function(String url) onAuthenticate;

  @override
  Future<String> authenticate({
    required String url,
    required String callbackUrlScheme,
    required Map<String, dynamic> options,
  }) => onAuthenticate(url);

  @override
  Future<void> clearAllDanglingCalls() async {}
}

/// A callback URL echoing the `state` from [authUrl], as a successful redirect would produce.
String successCallback(String authUrl, {String code = 'test-code'}) {
  final state = Uri.parse(authUrl).queryParameters['state'];
  return '$kOAuthRedirectUri?code=$code&state=$state';
}

MockClient tokenAndAccountClient() => MockClient((request) {
  switch (request.url.path) {
    case '/api/token':
      return mockResponse(_tokenResponse, 200);
    case '/api/account':
      return mockResponse(_accountResponse, 200);
    default:
      return mockResponse('', 404);
  }
});

void main() {
  // signIn() reaches WidgetsBinding.instance through flutter_web_auth_2, which the custom
  // LichessBinding does not provide.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthRepository.signIn', () {
    test('returns the authenticated user on success', () async {
      FlutterWebAuth2Platform.instance = FakeFlutterWebAuth2((url) async => successCallback(url));

      final container = await lichessClientContainer(tokenAndAccountClient());
      final authUser = await container.read(authRepositoryProvider).signIn();

      expect(authUser.token, 'test-token');
      expect(authUser.user.name, 'test');
    });

    test('exchanges the authorization code from the callback at the token endpoint', () async {
      FlutterWebAuth2Platform.instance = FakeFlutterWebAuth2((url) async => successCallback(url));

      String? tokenRequestBody;
      final mockClient = MockClient((request) {
        switch (request.url.path) {
          case '/api/token':
            tokenRequestBody = request.body;
            return mockResponse(_tokenResponse, 200);
          case '/api/account':
            return mockResponse(_accountResponse, 200);
          default:
            return mockResponse('', 404);
        }
      });

      final container = await lichessClientContainer(mockClient);
      await container.read(authRepositoryProvider).signIn();

      expect(tokenRequestBody, contains('grant_type=authorization_code'));
      expect(tokenRequestBody, contains('code=test-code'));
    });

    test('throws when the user cancels the auth session', () async {
      FlutterWebAuth2Platform.instance = FakeFlutterWebAuth2(
        (url) async => throw PlatformException(code: 'CANCELED'),
      );

      final container = await lichessClientContainer(tokenAndAccountClient());

      await expectLater(container.read(authRepositoryProvider).signIn(), throwsA(isA<Exception>()));
    });

    test('throws when the callback state does not match the request', () async {
      FlutterWebAuth2Platform.instance = FakeFlutterWebAuth2(
        (url) async => '$kOAuthRedirectUri?code=test-code&state=tampered',
      );

      final container = await lichessClientContainer(tokenAndAccountClient());

      await expectLater(container.read(authRepositoryProvider).signIn(), throwsA(isA<Exception>()));
    });

    test('throws when the callback carries an OAuth error', () async {
      FlutterWebAuth2Platform.instance = FakeFlutterWebAuth2((url) async {
        final state = Uri.parse(url).queryParameters['state'];
        return '$kOAuthRedirectUri?error=access_denied&state=$state';
      });

      final container = await lichessClientContainer(tokenAndAccountClient());

      await expectLater(container.read(authRepositoryProvider).signIn(), throwsA(isA<Exception>()));
    });

    test('throws when the callback has no authorization code', () async {
      FlutterWebAuth2Platform.instance = FakeFlutterWebAuth2((url) async {
        final state = Uri.parse(url).queryParameters['state'];
        return '$kOAuthRedirectUri?state=$state';
      });

      final container = await lichessClientContainer(tokenAndAccountClient());

      await expectLater(container.read(authRepositoryProvider).signIn(), throwsA(isA<Exception>()));
    });
  });
}

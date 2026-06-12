import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_container.dart';
import '../../test_helpers.dart';

const _accountResponse =
    '{"id":"test","username":"test","createdAt":1290415680000,"seenAt":1290415680000,"perfs":{}}';

/// Fake [FlutterAppAuth] that returns a canned token response (or throws) instead of opening a real
/// browser session and performing the OAuth code exchange.
class FakeFlutterAppAuth implements FlutterAppAuth {
  FakeFlutterAppAuth(this.onAuthorize);

  final Future<AuthorizationTokenResponse> Function(AuthorizationTokenRequest request) onAuthorize;

  @override
  Future<AuthorizationTokenResponse> authorizeAndExchangeCode(AuthorizationTokenRequest request) =>
      onAuthorize(request);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

AuthorizationTokenResponse tokenResponse({String? accessToken = 'test-token'}) =>
    AuthorizationTokenResponse(accessToken, null, null, null, 'Bearer', null, null, null);

FlutterAppAuthUserCancelledException userCancelled() => FlutterAppAuthUserCancelledException(
  code: 'user_cancelled',
  platformErrorDetails: FlutterAppAuthPlatformErrorDetails(),
);

MockClient accountClient() => MockClient((request) {
  switch (request.url.path) {
    case '/api/account':
      return mockResponse(_accountResponse, 200);
    default:
      return mockResponse('', 404);
  }
});

Future<ProviderContainer> appAuthContainer(MockClient mockClient, FlutterAppAuth appAuth) {
  return makeContainer(
    overrides: {
      httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
        return FakeHttpClientFactory(() => mockClient);
      }),
      appAuthProvider: appAuthProvider.overrideWith((ref) => appAuth),
    },
  );
}

void main() {
  group('AuthRepository.signIn', () {
    test('returns the authenticated user on success', () async {
      final container = await appAuthContainer(
        accountClient(),
        FakeFlutterAppAuth((request) async => tokenResponse()),
      );
      final authUser = await container.read(authRepositoryProvider).signIn();

      expect(authUser.token, 'test-token');
      expect(authUser.user.name, 'test');
    });

    test('requests the custom-scheme redirect URI', () async {
      String? redirectUrl;
      final container = await appAuthContainer(
        accountClient(),
        FakeFlutterAppAuth((request) async {
          redirectUrl = request.redirectUrl;
          return tokenResponse();
        }),
      );
      await container.read(authRepositoryProvider).signIn();

      expect(redirectUrl, kOAuthRedirectUri);
      expect(redirectUrl, startsWith('org.lichess.mobile://'));
    });

    test('throws SignInCancelledException when the user cancels the auth session', () async {
      final container = await appAuthContainer(
        accountClient(),
        FakeFlutterAppAuth((request) async => throw userCancelled()),
      );

      await expectLater(
        container.read(authRepositoryProvider).signIn(),
        throwsA(isA<SignInCancelledException>()),
      );
    });

    test('rethrows non-cancellation errors', () async {
      final container = await appAuthContainer(
        accountClient(),
        FakeFlutterAppAuth((request) async => throw Exception('authorization failed')),
      );

      await expectLater(
        container.read(authRepositoryProvider).signIn(),
        throwsA(
          isA<Exception>().having(
            (e) => e,
            'is not a cancellation',
            isNot(isA<SignInCancelledException>()),
          ),
        ),
      );
    });

    test('throws when no access token is returned', () async {
      final container = await appAuthContainer(
        accountClient(),
        FakeFlutterAppAuth((request) async => tokenResponse(accessToken: null)),
      );

      await expectLater(container.read(authRepositoryProvider).signIn(), throwsA(isA<Exception>()));
    });
  });
}

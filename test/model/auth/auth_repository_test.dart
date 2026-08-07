import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';
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

/// Container for the email login flow, which needs no [FlutterAppAuth].
Future<ProviderContainer> emailLoginContainer(MockClientHandler handler) {
  return makeContainer(
    overrides: {
      httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
        return FakeHttpClientFactory(() => MockClient(handler));
      }),
    },
  );
}

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

  group('AuthRepository.requestEmailLoginCode', () {
    test('posts the email as a query parameter', () async {
      Uri? requestedUrl;
      final container = await emailLoginContainer((request) {
        requestedUrl = request.url;
        return mockResponse('', 204);
      });

      await container.read(authRepositoryProvider).requestEmailLoginCode('johndoe@lichess.org');

      expect(requestedUrl?.path, '/auth/mobile-code/email');
      expect(requestedUrl?.queryParameters, {'email': 'johndoe@lichess.org'});
    });

    test('throws EmailLoginRateLimitException on 429', () async {
      final container = await emailLoginContainer((request) => mockResponse('', 429));

      await expectLater(
        container.read(authRepositoryProvider).requestEmailLoginCode('johndoe@lichess.org'),
        throwsA(isA<EmailLoginRateLimitException>()),
      );
    });

    test('throws a ServerException on other errors', () async {
      final container = await emailLoginContainer((request) => mockResponse('', 500));

      await expectLater(
        container.read(authRepositoryProvider).requestEmailLoginCode('johndoe@lichess.org'),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('AuthRepository.signInWithEmailCode', () {
    test('exchanges the code for a token and returns the authenticated user', () async {
      Uri? requestedUrl;
      final container = await emailLoginContainer((request) {
        switch (request.url.path) {
          case '/auth/mobile-code/bearer':
            requestedUrl = request.url;
            return mockResponse('lio_token', 200);
          case '/api/account':
            return mockResponse(_accountResponse, 200);
          default:
            return mockResponse('', 404);
        }
      });

      final authUser = await container
          .read(authRepositoryProvider)
          .signInWithEmailCode(email: 'johndoe@lichess.org', code: 'xxxxxx');

      expect(requestedUrl?.queryParameters, {'email': 'johndoe@lichess.org', 'code': 'xxxxxx'});
      expect(authUser.token, 'lio_token');
      expect(authUser.user.name, 'test');
    });

    test('sends the signed token when fetching the account', () async {
      String? authorization;
      final container = await emailLoginContainer((request) {
        switch (request.url.path) {
          case '/auth/mobile-code/bearer':
            return mockResponse('lio_token', 200);
          case '/api/account':
            authorization = request.headers['Authorization'];
            return mockResponse(_accountResponse, 200);
          default:
            return mockResponse('', 404);
        }
      });

      await container
          .read(authRepositoryProvider)
          .signInWithEmailCode(email: 'johndoe@lichess.org', code: 'xxxxxx');

      expect(authorization, 'Bearer ${signBearerToken('lio_token')}');
    });

    test('throws InvalidEmailLoginCodeException on 404', () async {
      final container = await emailLoginContainer((request) => mockResponse('', 404));

      await expectLater(
        container
            .read(authRepositoryProvider)
            .signInWithEmailCode(email: 'johndoe@lichess.org', code: 'expire'),
        throwsA(isA<InvalidEmailLoginCodeException>()),
      );
    });

    test('throws EmailLoginRateLimitException on 429', () async {
      final container = await emailLoginContainer((request) => mockResponse('', 429));

      await expectLater(
        container
            .read(authRepositoryProvider)
            .signInWithEmailCode(email: 'johndoe@lichess.org', code: 'xxxxxx'),
        throwsA(isA<EmailLoginRateLimitException>()),
      );
    });

    test('throws when the response body holds no token', () async {
      final container = await emailLoginContainer((request) => mockResponse('  ', 200));

      await expectLater(
        container
            .read(authRepositoryProvider)
            .signInWithEmailCode(email: 'johndoe@lichess.org', code: 'xxxxxx'),
        throwsA(isA<Exception>()),
      );
    });
  });
}

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_storage.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_container.dart';
import '../../test_helpers.dart';
import 'fake_auth_storage.dart';

const _accountResponse =
    '{"id":"newuser","username":"newUser","createdAt":1290415680000,"seenAt":1290415680000,"perfs":{}}';

const _otherAuthUser = AuthUser(
  token: 'otherToken',
  user: LightUser(id: UserId('otheruser'), name: 'otherUser'),
);

const _anotherAuthUser = AuthUser(
  token: 'anotherToken',
  user: LightUser(id: UserId('anotheruser'), name: 'anotherUser'),
);

/// Makes a container signed in to [authUser], also signed in to the [others] accounts.
///
/// The tokens in [validTokens] are the ones `/api/token/test` reports as valid.
Future<ProviderContainer> _makeContainer({
  AuthUser? authUser = fakeAuthUser,
  IList<AuthUser> others = const IListConst([]),
  Set<String> validTokens = const {},
}) async {
  final container = await makeContainer(
    authUser: authUser,
    overrides: {
      httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
        return FakeHttpClientFactory(
          () => MockClient((request) {
            switch (request.url.path) {
              case '/auth/mobile-code/bearer':
                return mockResponse('newToken', 200);
              case '/api/account':
                return mockResponse(_accountResponse, 200);
              case '/api/token/test':
                final token = request.body;
                return mockResponse(
                  validTokens.contains(token) ? '{"$token":{"userId":"x"}}' : '{"$token":null}',
                  200,
                );
              case '/api/token':
                return mockResponse('', 204);
              default:
                return Future.value(http.Response('', 200));
            }
          }),
        );
      }),
    },
  );

  const storage = AuthStorage();
  if (authUser != null) await storage.write(authUser);
  await storage.writeOthers(others);

  // The auth controller is auto disposed: keep it alive for the duration of the test.
  container.listen(authControllerProvider, (_, _) {});

  return container;
}

Future<void> _signInWithEmailCode(ProviderContainer container) {
  return container
      .read(authControllerProvider.notifier)
      .signInWithEmailCode(username: 'newUser', email: 'new@lichess.org', code: 'xxxxxx');
}

void main() {
  group('AuthController', () {
    test('signing in while signed in keeps the previous account', () async {
      final container = await _makeContainer(others: IList(const [_otherAuthUser]));

      await _signInWithEmailCode(container);

      expect(container.read(authControllerProvider)?.user.id, const UserId('newuser'));
      expect(await const AuthStorage().read(), container.read(authControllerProvider));
      expect(await const AuthStorage().readOthers(), IList(const [fakeAuthUser, _otherAuthUser]));
    });

    test('signing in again to an account replaces its session', () async {
      final container = await _makeContainer(
        authUser: null,
        others: IList(const [
          AuthUser(
            token: 'oldToken',
            user: LightUser(id: UserId('newuser'), name: 'newUser'),
          ),
        ]),
      );

      await _signInWithEmailCode(container);

      expect(container.read(authControllerProvider)?.token, 'newToken');
      expect(await const AuthStorage().readOthers(), isEmpty);
    });

    test('switchAccount makes the other account active', () async {
      final container = await _makeContainer(
        others: IList(const [_otherAuthUser, _anotherAuthUser]),
        validTokens: {_anotherAuthUser.token},
      );

      await container.read(authControllerProvider.notifier).switchAccount(_anotherAuthUser);

      expect(container.read(authControllerProvider), _anotherAuthUser);
      expect(await const AuthStorage().read(), _anotherAuthUser);
      expect(await const AuthStorage().readOthers(), IList(const [fakeAuthUser, _otherAuthUser]));
    });

    test('switchAccount to an expired session forgets the account', () async {
      final container = await _makeContainer(others: IList(const [_otherAuthUser]));

      await expectLater(
        container.read(authControllerProvider.notifier).switchAccount(_otherAuthUser),
        throwsA(isA<AccountSessionExpiredException>()),
      );

      expect(container.read(authControllerProvider), fakeAuthUser);
      expect(await const AuthStorage().readOthers(), isEmpty);
    });

    test('signOut makes the most recently used other account active', () async {
      final container = await _makeContainer(
        others: IList(const [_otherAuthUser, _anotherAuthUser]),
      );

      await container.read(authControllerProvider.notifier).signOut();

      expect(container.read(authControllerProvider), _otherAuthUser);
      expect(await const AuthStorage().read(), _otherAuthUser);
      expect(await const AuthStorage().readOthers(), IList(const [_anotherAuthUser]));
    });

    test('signOut without other accounts signs the user out', () async {
      final container = await _makeContainer();

      await container.read(authControllerProvider.notifier).signOut();

      expect(container.read(authControllerProvider), isNull);
      expect(await const AuthStorage().read(), isNull);
    });
  });
}

import 'package:clock/clock.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_storage.dart';
import 'package:lichess_mobile/src/model/auth/parental_pin.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_container.dart';
import '../../test_helpers.dart';
import 'fake_auth_storage.dart';

const _otherAuthUser = AuthUser(
  token: 'otherToken',
  user: LightUser(id: UserId('otheruser'), name: 'otherUser'),
);

/// Makes a container signed in to [fakeAuthUser] and [_otherAuthUser].
///
/// `/api/account` answers with [kid] as the kid mode, or fails if [kid] is null. The requests made
/// are added to [requests].
Future<ProviderContainer> _makeContainer({bool? kid = false, List<http.Request>? requests}) async {
  final container = await makeContainer(
    authUser: fakeAuthUser,
    overrides: {
      httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
        return FakeHttpClientFactory(
          () => MockClient((request) {
            requests?.add(request);
            switch (request.url.path) {
              case '/api/account':
                return kid == null
                    ? mockResponse('', 500)
                    : mockResponse(
                        '{"id":"testuser","username":"testUser","createdAt":1290415680000,'
                        '"seenAt":1290415680000,"perfs":{},"kid":$kid}',
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
  await storage.write(fakeAuthUser);
  await storage.writeOthers(IList(const [_otherAuthUser]));
  container.listen(authControllerProvider, (_, _) {});
  return container;
}

Matcher _wrong(DateTime? lockedUntil) =>
    isA<ParentalPinWrong>().having((w) => w.lockedUntil, 'lockedUntil', lockedUntil);

void main() {
  group('ParentalPinController', () {
    test('no PIN is set by default', () async {
      final container = await _makeContainer();

      expect(await container.read(parentalPinProvider.future), isFalse);
    });

    test('a set PIN matches only itself', () async {
      final container = await _makeContainer();
      final controller = container.read(parentalPinProvider.notifier);

      await controller.setPin('1234');

      expect(container.read(parentalPinProvider).value, isTrue);
      expect(await controller.verify('1234'), isA<ParentalPinCorrect>());
      expect(await controller.verify('4321'), isA<ParentalPinWrong>());
    });

    test('too many wrong PINs lock the PIN for longer and longer', () async {
      final container = await _makeContainer();
      final controller = container.read(parentalPinProvider.notifier);
      await controller.setPin('1234');
      final now = DateTime(2026, 11, 13, 12);

      await withClock(Clock.fixed(now), () async {
        for (var i = 1; i < kParentalPinFreeAttempts; i++) {
          expect(await controller.verify('0000'), _wrong(null));
        }
        expect(await controller.verify('0000'), _wrong(now.add(const Duration(seconds: 30))));
        // Locked: even the right PIN is not checked.
        expect(
          await controller.verify('1234'),
          isA<ParentalPinLocked>().having(
            (l) => l.lockedUntil,
            'lockedUntil',
            now.add(const Duration(seconds: 30)),
          ),
        );
      });

      final later = now.add(const Duration(seconds: 31));
      await withClock(Clock.fixed(later), () async {
        expect(await controller.verify('0000'), _wrong(later.add(const Duration(minutes: 1))));
      });
    });

    test('the wrong attempts survive an app restart', () async {
      final container = await _makeContainer();
      final controller = container.read(parentalPinProvider.notifier);
      await controller.setPin('1234');
      for (var i = 0; i < kParentalPinFreeAttempts; i++) {
        await controller.verify('0000');
      }

      container.invalidate(parentalPinProvider);

      expect(
        await container.read(parentalPinProvider.notifier).verify('1234'),
        isA<ParentalPinLocked>(),
      );
    });

    test('the right PIN resets the wrong attempts', () async {
      final container = await _makeContainer();
      final controller = container.read(parentalPinProvider.notifier);
      await controller.setPin('1234');
      for (var i = 1; i < kParentalPinFreeAttempts; i++) {
        await controller.verify('0000');
      }

      await controller.verify('1234');

      expect(await controller.verify('0000'), _wrong(null));
    });

    group('isRequiredToLeaveAccount', () {
      test('is false without a PIN, even in kid mode', () async {
        final container = await _makeContainer(kid: true);

        expect(
          await container.read(parentalPinProvider.notifier).isRequiredToLeaveAccount(),
          isFalse,
        );
      });

      test('is true with a PIN in kid mode', () async {
        final container = await _makeContainer(kid: true);
        final controller = container.read(parentalPinProvider.notifier);
        await controller.setPin('1234');

        expect(await controller.isRequiredToLeaveAccount(), isTrue);
      });

      test('is false with a PIN outside kid mode', () async {
        final container = await _makeContainer();
        final controller = container.read(parentalPinProvider.notifier);
        await controller.setPin('1234');

        expect(await controller.isRequiredToLeaveAccount(), isFalse);
      });

      test('is true with a PIN when the kid mode cannot be fetched', () async {
        final container = await _makeContainer(kid: null);
        final controller = container.read(parentalPinProvider.notifier);
        await controller.setPin('1234');

        expect(await controller.isRequiredToLeaveAccount(), isTrue);
      });
    });

    test('forgetting the PIN signs out of every account and revokes their tokens', () async {
      final requests = <http.Request>[];
      final container = await _makeContainer(requests: requests);
      final controller = container.read(parentalPinProvider.notifier);
      await controller.setPin('1234');

      await controller.forgetPin();
      await pumpEventQueue();

      expect(container.read(parentalPinProvider).value, isFalse);
      expect(container.read(authControllerProvider), isNull);
      expect(await const AuthStorage().read(), isNull);
      expect(await const AuthStorage().readOthers(), isEmpty);
      expect(
        requests.where((r) => r.method == 'DELETE' && r.url.path == '/api/token'),
        hasLength(2),
      );
    });
  });
}

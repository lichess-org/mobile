import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/session_storage.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock_server_responses.dart';
import '../../network/fake_http_client_factory.dart';
import '../../test_container.dart';
import '../../test_helpers.dart';

class MockFlutterAppAuth extends Mock implements FlutterAppAuth {}

class MockSessionStorage extends Mock implements SessionStorage {}

class Listener<T> extends Mock {
  void call(T? previous, T value);
}

void main() {
  final mockSessionStorage = MockSessionStorage();
  final mockFlutterAppAuth = MockFlutterAppAuth();

  const testUserSession = AuthSessionState(
    token: 'testToken',
    user: LightUser(id: UserId('test'), name: 'test', title: 'GM', patronColor: 1),
  );
  const loading = AsyncLoading<void>();
  const nullData = AsyncData<void>(null);

  final client = MockClient((request) {
    if (request.url.path == '/api/account') {
      return mockResponse(mockApiAccountResponse(testUserSession.user.name), 200);
    } else if (request.method == 'DELETE' && request.url.path == '/api/token') {
      return mockResponse('ok', 200);
    } else if (request.method == 'POST' && request.url.path == '/mobile/unregister') {
      return mockResponse('ok', 200);
    }
    return mockResponse('', 404);
  });

  setUpAll(() {
    registerFallbackValue(
      AuthorizationTokenRequest(
        'testClientId',
        'testRedirectUrl',
        discoveryUrl: 'testDiscoveryUrl',
        scopes: ['testScope'],
      ),
    );
    registerFallbackValue(testUserSession);
    registerFallbackValue(const AsyncLoading<void>());
  });

  setUp(() {
    reset(mockFlutterAppAuth);
    reset(mockSessionStorage);
  });

  group('AuthController', () {
    test('sign in', () async {
      when(() => mockSessionStorage.read()).thenAnswer((_) => Future.value(null));
      when(
        () => mockFlutterAppAuth.authorizeAndExchangeCode(any()),
      ).thenAnswer((_) => Future.value(signInResponse));
      when(() => mockSessionStorage.write(any())).thenAnswer((_) => Future.value(null));

      final container = await makeContainer(
        overrides: {
          appAuthProvider: appAuthProvider.overrideWithValue(mockFlutterAppAuth),
          sessionStorageProvider: sessionStorageProvider.overrideWithValue(mockSessionStorage),
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (_) => FakeHttpClientFactory(() => client),
          ),
        },
      );

      final listener = Listener<AsyncValue<void>>();

      container.listen<AsyncValue<void>>(
        authControllerProvider,
        listener.call,
        fireImmediately: true,
      );

      final controller = container.read(authControllerProvider.notifier);
      await controller.signIn();

      verifyInOrder([
        // init state
        () => listener(null, loading),
        // signin logic completed
        () => listener(loading, nullData),
      ]);
      verifyNoMoreInteractions(listener);

      // it should successfully write the session
      verify(() => mockSessionStorage.write(testUserSession)).called(1);
    });

    test('sign out', () async {
      when(() => mockSessionStorage.read()).thenAnswer((_) => Future.value(testUserSession));
      when(() => mockSessionStorage.delete()).thenAnswer((_) => Future.value(null));

      int tokenDeleteCount = 0;
      int unregisterCount = 0;

      final client = MockClient((request) {
        if (request.method == 'DELETE' && request.url.path == '/api/token') {
          tokenDeleteCount++;
          return mockResponse('ok', 200);
        } else if (request.method == 'POST' && request.url.path == '/mobile/unregister') {
          unregisterCount++;
          return mockResponse('ok', 200);
        }
        return mockResponse('', 404);
      });

      final container = await makeContainer(
        overrides: {
          appAuthProvider: appAuthProvider.overrideWithValue(mockFlutterAppAuth),
          sessionStorageProvider: sessionStorageProvider.overrideWithValue(mockSessionStorage),
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (_) => FakeHttpClientFactory(() => client),
          ),
        },
        userSession: testUserSession,
      );

      final listener = Listener<AsyncValue<void>>();

      container.listen<AsyncValue<void>>(
        authControllerProvider,
        listener.call,
        fireImmediately: true,
      );

      final controller = container.read(authControllerProvider.notifier);
      await controller.signOut();

      verifyInOrder([
        // init state
        () => listener(null, loading),
        // signOut logic completed
        () => listener(loading, nullData),
      ]);
      verifyNoMoreInteractions(listener);

      expect(tokenDeleteCount, 1, reason: 'token should be deleted');
      expect(unregisterCount, 1, reason: 'device should be unregistered');

      // session should be deleted
      verify(() => mockSessionStorage.delete()).called(1);
    });
  });
}

final signInResponse = AuthorizationTokenResponse(
  'testToken',
  null,
  null,
  null,
  null,
  null,
  null,
  null,
);

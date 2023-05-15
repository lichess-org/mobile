import 'package:async/async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/testing.dart';

import 'package:lichess_mobile/src/http_client.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/model/auth/session_storage.dart';
import 'package:lichess_mobile/src/model/auth/user_session.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import '../../test_utils.dart';
import '../../test_container.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSessionStorage extends Mock implements SessionStorage {}

class Listener<T> extends Mock {
  void call(T? previous, T value);
}

void main() {
  final mockSessionStorage = MockSessionStorage();
  final mockAuthRepository = MockAuthRepository();

  final mockClient = MockClient((request) {
    if (request.url.path == '/api/account') {
      return mockResponse(testAccountResponse, 200);
    } else if (request.method == 'DELETE' && request.url.path == '/api/token') {
      return mockResponse('ok', 200);
    }
    return mockResponse('', 404);
  });

  const testUserSession = UserSession(
    token: 'testToken',
    user: LightUser(
      id: UserId('test'),
      name: 'test',
      title: 'GM',
      isPatron: true,
    ),
  );
  const loading = AsyncLoading<void>();
  const nullData = AsyncData<void>(null);

  setUpAll(() {
    registerFallbackValue(testUserSession);
    registerFallbackValue(const AsyncLoading<void>());
  });

  setUp(() {
    reset(mockAuthRepository);
    reset(mockSessionStorage);
  });

  group('AuthController', () {
    test('sign in', () async {
      when(() => mockSessionStorage.read())
          .thenAnswer((_) => delayedAnswer(null));
      when(() => mockAuthRepository.signIn())
          .thenAnswer((_) => delayedAnswer(signInResponse));
      when(
        () => mockSessionStorage.write(any()),
      ).thenAnswer((_) => delayedAnswer(null));

      final container = await makeContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          sessionStorageProvider.overrideWithValue(mockSessionStorage),
          httpClientProvider.overrideWithValue(mockClient),
        ],
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
        () => listener(null, nullData),
        // state is loading, waiting for signin logic to complete
        () => listener(nullData, loading),
        // signin logic completed
        () => listener(loading, nullData),
      ]);
      verifyNoMoreInteractions(listener);
      verify(mockAuthRepository.signIn).called(1);

      // it should successfully write the session
      verify(
        () => mockSessionStorage.write(testUserSession),
      ).called(1);
    });

    test('sign out', () async {
      when(() => mockSessionStorage.read())
          .thenAnswer((_) => delayedAnswer(testUserSession));
      when(() => mockAuthRepository.signOut())
          .thenAnswer((_) => delayedAnswer(Result.value(null)));
      when(
        () => mockSessionStorage.delete(),
      ).thenAnswer((_) => delayedAnswer(null));

      final container = await makeContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          sessionStorageProvider.overrideWithValue(mockSessionStorage),
          httpClientProvider.overrideWithValue(mockClient),
        ],
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
        () => listener(null, nullData),
        // state is loading, waiting for signin logic to complete
        () => listener(nullData, loading),
        // signOut logic completed
        () => listener(loading, nullData),
      ]);
      verifyNoMoreInteractions(listener);
      verify(mockAuthRepository.signOut).called(1);

      // session should be deleted
      verify(
        () => mockSessionStorage.delete(),
      ).called(1);
    });
  });
}

const testAccountResponse = '''
{
  "id": "test",
  "username": "test",
  "createdAt": 1290415680000,
  "seenAt": 1290415680000,
  "title": "GM",
  "patron": true,
  "perfs": {
    "blitz": {
      "games": 2340,
      "rating": 1681,
      "rd": 30,
      "prog": 10
    },
    "rapid": {
      "games": 2340,
      "rating": 1677,
      "rd": 30,
      "prog": 10
    },
    "classical": {
      "games": 2340,
      "rating": 1618,
      "rd": 30,
      "prog": 10
    }
  },
  "profile": {
    "country": "France",
    "location": "Lille",
    "bio": "test bio",
    "firstName": "John",
    "lastName": "Doe",
    "fideRating": 1800,
    "links": "http://test.com"
  }
}
''';

final signInResponse = Result.value(
  AuthorizationTokenResponse(
    'testToken',
    null,
    null,
    null,
    null,
    null,
    null,
    null,
  ),
);

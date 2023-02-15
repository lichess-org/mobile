import 'package:async/async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/model/auth/session_repository.dart';
import 'package:lichess_mobile/src/model/auth/user_session.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import '../../utils.dart';

class MockClient extends Mock implements http.Client {}

class MockLogger extends Mock implements Logger {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSessionRepository extends Mock implements SessionRepository {}

class Listener<T> extends Mock {
  void call(T? previous, T value);
}

void main() {
  final mockClient = MockClient();
  final mockLogger = MockLogger();
  final mockSessionRepository = MockSessionRepository();
  final mockAuthRepository = MockAuthRepository();

  const testUserSession = UserSession(
    token: 'testToken',
    user: LightUser(
      id: UserId('test'),
      name: 'test',
      title: 'GM',
      isPatron: true,
    ),
  );
  const loading = AsyncLoading<UserSession?>();
  const sessionData = AsyncData<UserSession?>(testUserSession);
  const nullData = AsyncData<UserSession?>(null);

  ProviderContainer makeContainer(
    MockAuthRepository authRepository,
    MockSessionRepository sessionRepository,
  ) {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        sessionRepositoryProvider.overrideWithValue(sessionRepository),
        apiClientProvider.overrideWithValue(ApiClient(mockLogger, mockClient)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUpAll(() {
    when(
      () => mockClient.get(
        Uri.parse('$kLichessHost/api/account'),
        headers: any(
          named: 'headers',
          that: sameHeaders({'Authorization': 'Bearer testToken'}),
        ),
      ),
    ).thenAnswer((_) => mockResponse(testAccountResponse, 200));

    registerFallbackValue(testUserSession);
  });

  setUp(() {
    reset(mockAuthRepository);
    reset(mockSessionRepository);

    when(
      () => mockSessionRepository.write(any()),
    ).thenAnswer((_) => delayedAnswer(null));
  });

  group('AuthController', () {
    test('loads the session from session repository', () async {
      when(() => mockSessionRepository.read())
          .thenAnswer((_) => delayedAnswer(testUserSession));

      final container =
          makeContainer(mockAuthRepository, mockSessionRepository);

      final listener = Listener<AsyncValue<UserSession?>>();

      container.listen<AsyncValue<UserSession?>>(
        authControllerProvider,
        listener,
        fireImmediately: true,
      );

      await container.read(authControllerProvider.future);

      verifyInOrder([
        () => listener(null, loading),
        () => listener(loading, sessionData),
      ]);
      verifyNoMoreInteractions(listener);
    });

    test('sign in', () async {
      when(() => mockSessionRepository.read())
          .thenAnswer((_) => delayedAnswer(null));
      when(() => mockAuthRepository.signIn())
          .thenAnswer((_) => delayedAnswer(signInResponse));

      final container =
          makeContainer(mockAuthRepository, mockSessionRepository);

      final listener = Listener<AsyncValue<UserSession?>>();

      container.listen<AsyncValue<UserSession?>>(
        authControllerProvider,
        listener,
        fireImmediately: true,
      );

      final controller = container.read(authControllerProvider.notifier);

      await controller.signIn();

      verifyInOrder([
        () => listener(null, loading),
        () => listener(loading, nullData),
        // () => listener(nullData, loading),
        () => listener(nullData, sessionData),
      ]);
      verifyNoMoreInteractions(listener);
      verify(mockAuthRepository.signIn).called(1);
      verify(
        () => mockSessionRepository.write(testUserSession),
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

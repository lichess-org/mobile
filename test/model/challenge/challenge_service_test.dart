import 'package:fake_async/fake_async.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_service.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart' show currentNavigatorKeyProvider;
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../../network/fake_websocket_channel.dart';
import '../../network/socket_test.dart';
import '../../test_container.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';
import '../auth/fake_auth_storage.dart';

class NotificationDisplayMock extends Mock implements FlutterLocalNotificationsPlugin {}

class MockChallengeRepository extends Mock implements ChallengeRepository {}

class _ShowConfirmDialogWidget extends ConsumerWidget {
  const _ShowConfirmDialogWidget({required this.challenge});

  final Challenge challenge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => ref.read(challengeServiceProvider).showConfirmDialog(context, challenge),
      child: const Text('Open Dialog'),
    );
  }
}

class _ShowDeclineDialogWidget extends ConsumerWidget {
  const _ShowDeclineDialogWidget({required this.challengeId});

  final ChallengeId challengeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => ref.read(challengeServiceProvider).showDeclineDialog(context, challengeId),
      child: const Text('Open Dialog'),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(const ChallengeId(''));
    registerFallbackValue(ChallengeDeclineReason.generic);
  });

  final notificationDisplayMock = NotificationDisplayMock();

  tearDown(() {
    reset(notificationDisplayMock);
  });

  test('exposes a challenges stream', () async {
    final socketClient = makeTestSocketClient();
    await socketClient.connect();
    await socketClient.firstConnection;
    sendServerSocketMessages(Uri(path: kDefaultSocketRoute), [
      '''
{"t": "challenges", "d": {"in": [ { "socketVersion": 0, "id": "H9fIRZUk", "url": "https://lichess.org/H9fIRZUk", "status": "created", "challenger": { "id": "bot1", "name": "Bot1", "rating": 1500, "title": "BOT", "provisional": true, "online": true, "lag": 4 }, "destUser": { "id": "bobby", "name": "Bobby", "rating": 1635, "title": "GM", "provisional": true, "online": true, "lag": 4 }, "variant": { "key": "standard", "name": "Standard", "short": "Std" }, "rated": true, "speed": "rapid", "timeControl": { "type": "clock", "limit": 600, "increment": 0, "show": "10+0" }, "color": "random", "finalColor": "black", "perf": { "icon": "", "name": "Rapid" }, "direction": "in" } ] }, "v": 0 }
''',
    ]);

    await expectLater(
      ChallengeService.stream,
      emitsInOrder([
        const (
          inward: IListConst<Challenge>([
            Challenge(
              socketVersion: 0,
              id: ChallengeId('H9fIRZUk'),
              status: ChallengeStatus.created,
              challenger: (
                user: LightUser(id: UserId('bot1'), name: 'Bot1', title: 'BOT', isOnline: true),
                rating: 1500,
                provisionalRating: true,
                lagRating: 4,
              ),
              destUser: (
                user: LightUser(id: UserId('bobby'), name: 'Bobby', title: 'GM', isOnline: true),
                rating: 1635,
                provisionalRating: true,
                lagRating: 4,
              ),
              variant: Variant.standard,
              rated: true,
              speed: Speed.rapid,
              timeControl: ChallengeTimeControlType.clock,
              clock: (time: Duration(seconds: 600), increment: Duration.zero),
              sideChoice: SideChoice.random,
              direction: ChallengeDirection.inward,
            ),
          ]),
          outward: IListConst<Challenge>([]),
        ),
      ]),
    );

    socketClient.close();
  });

  test('Listen to socket and show a notification for any new challenge', () async {
    when(
      () => notificationDisplayMock.show(
        id: any(named: 'id'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        notificationDetails: any(named: 'notificationDetails'),
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) => Future.value());

    final container = await makeContainer(
      authUser: fakeAuthUser,
      overrides: {
        notificationDisplayProvider: notificationDisplayProvider.overrideWithValue(
          notificationDisplayMock,
        ),
      },
    );

    final notificationService = container.read(notificationServiceProvider);
    final challengeService = container.read(challengeServiceProvider);

    fakeAsync((async) {
      final socketClient = makeTestSocketClient();
      socketClient.connect();
      notificationService.start();
      challengeService.start();

      // wait for the socket to connect
      async.elapse(const Duration(milliseconds: 100));
      async.flushMicrotasks();

      sendServerSocketMessages(Uri(path: kDefaultSocketRoute), [
        '''
{"t": "challenges", "d": {"in": [ { "socketVersion": 0, "id": "H9fIRZUk", "url": "https://lichess.org/H9fIRZUk", "status": "created", "challenger": { "id": "bot1", "name": "Bot1", "rating": 1500, "title": "BOT", "provisional": true, "online": true, "lag": 4 }, "destUser": { "id": "bobby", "name": "Bobby", "rating": 1635, "title": "GM", "provisional": true, "online": true, "lag": 4 }, "variant": { "key": "standard", "name": "Standard", "short": "Std" }, "rated": true, "speed": "rapid", "timeControl": { "type": "clock", "limit": 600, "increment": 0, "show": "10+0" }, "color": "random", "finalColor": "black", "perf": { "icon": "", "name": "Rapid" }, "direction": "in" } ] }, "v": 0 }
''',
      ]);

      async.flushMicrotasks();

      final result = verify(
        () => notificationDisplayMock.show(
          id: const ChallengeId('H9fIRZUk').hashCode,
          title: 'Bot1 challenges you!',
          body: 'Random side • Rated • 10+0',
          notificationDetails: captureAny(named: 'notificationDetails'),
          payload: any(named: 'payload'),
        ),
      );

      expectLater(result.callCount, 1);
      expectLater(
        result.captured[0],
        isA<NotificationDetails>()
            .having((details) => details.android?.channelId, 'channelId', 'challenge')
            .having((d) => d.android?.importance, 'importance', Importance.max)
            .having((d) => d.android?.priority, 'priority', Priority.high),
      );

      sendServerSocketMessages(Uri(path: kDefaultSocketRoute), [
        '''
{"t": "challenges", "d": {"in": [ { "socketVersion": 0, "id": "H9fIRZUk", "url": "https://lichess.org/H9fIRZUk", "status": "created", "challenger": { "id": "bot1", "name": "Bot1", "rating": 1500, "title": "BOT", "provisional": true, "online": true, "lag": 4 }, "destUser": { "id": "bobby", "name": "Bobby", "rating": 1635, "title": "GM", "provisional": true, "online": true, "lag": 4 }, "variant": { "key": "standard", "name": "Standard", "short": "Std" }, "rated": true, "speed": "rapid", "timeControl": { "type": "clock", "limit": 600, "increment": 0, "show": "10+0" }, "color": "random", "finalColor": "black", "perf": { "icon": "", "name": "Rapid" }, "direction": "in" } ] }, "v": 0 }
''',
      ]);

      async.flushMicrotasks();

      // same notification should not be shown again
      verifyNever(
        () => notificationDisplayMock.show(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          notificationDetails: any(named: 'notificationDetails'),
          payload: any(named: 'payload'),
        ),
      );

      // closing the socket client to be able to flush the timers
      socketClient.close();
      async.flushTimers();
    });
  });

  test('Cancels the notification for any missing challenge', () async {
    when(
      () => notificationDisplayMock.show(
        id: any(named: 'id'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        notificationDetails: any(named: 'notificationDetails'),
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) => Future.value());

    when(
      () => notificationDisplayMock.cancel(id: any(named: 'id')),
    ).thenAnswer((_) => Future.value());

    final container = await makeContainer(
      authUser: fakeAuthUser,
      overrides: {
        notificationDisplayProvider: notificationDisplayProvider.overrideWithValue(
          notificationDisplayMock,
        ),
      },
    );

    final notificationService = container.read(notificationServiceProvider);
    final challengeService = container.read(challengeServiceProvider);

    fakeAsync((async) {
      final socketClient = makeTestSocketClient();
      socketClient.connect();
      notificationService.start();
      challengeService.start();

      // wait for the socket to connect
      async.elapse(const Duration(milliseconds: 100));
      async.flushMicrotasks();

      sendServerSocketMessages(Uri(path: kDefaultSocketRoute), [
        '''
{"t": "challenges", "d": {"in": [ { "socketVersion": 0, "id": "H9fIRZUk", "url": "https://lichess.org/H9fIRZUk", "status": "created", "challenger": { "id": "bot1", "name": "Bot1", "rating": 1500, "title": "BOT", "provisional": true, "online": true, "lag": 4 }, "destUser": { "id": "bobby", "name": "Bobby", "rating": 1635, "title": "GM", "provisional": true, "online": true, "lag": 4 }, "variant": { "key": "standard", "name": "Standard", "short": "Std" }, "rated": true, "speed": "rapid", "timeControl": { "type": "clock", "limit": 600, "increment": 0, "show": "10+0" }, "color": "random", "finalColor": "black", "perf": { "icon": "", "name": "Rapid" }, "direction": "in" } ] }, "v": 0 }
''',
      ]);

      async.flushMicrotasks();

      verify(
        () => notificationDisplayMock.show(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          notificationDetails: any(named: 'notificationDetails'),
          payload: any(named: 'payload'),
        ),
      );

      sendServerSocketMessages(Uri(path: kDefaultSocketRoute), [
        '''
{"t": "challenges", "d": {"in": [] }, "v": 0 }
''',
      ]);

      async.flushMicrotasks();

      verify(
        () => notificationDisplayMock.cancel(id: const ChallengeId('H9fIRZUk').hashCode),
      ).called(1);

      // closing the socket client to be able to flush the timers
      socketClient.close();
      async.flushTimers();
    });
  });

  group('showConfirmDialog', () {
    testWidgets('shows title with challenger name when challenger is present', (tester) async {
      const challenge = Challenge(
        id: ChallengeId('H9fIRZUk'),
        status: ChallengeStatus.created,
        challenger: (
          user: LightUser(id: UserId('bot1'), name: 'Bot1', title: 'BOT', isOnline: true),
          rating: 1500,
          provisionalRating: true,
          lagRating: 4,
        ),
        destUser: (
          user: LightUser(id: UserId('bobby'), name: 'Bobby', title: 'GM', isOnline: true),
          rating: 1635,
          provisionalRating: true,
          lagRating: 4,
        ),
        variant: Variant.standard,
        rated: true,
        speed: Speed.rapid,
        timeControl: ChallengeTimeControlType.clock,
        clock: (time: Duration(seconds: 600), increment: Duration.zero),
        sideChoice: SideChoice.random,
      );

      final app = await makeTestProviderScopeApp(
        tester,
        home: const _ShowConfirmDialogWidget(challenge: challenge),
      );
      await tester.pumpWidget(app);
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Bot1 challenges you: Random side • Rated • 10+0'), findsOneWidget);
      expect(find.text('Accept'), findsOneWidget);
      expect(find.text('Decline'), findsOneWidget);
    }, variant: kPlatformVariant);

    testWidgets('shows no title for open challenge without challenger', (tester) async {
      // Regression test: previously crashed with a null assertion on challenge.challenger!
      const challenge = Challenge(
        id: ChallengeId('H9fIRZUk'),
        status: ChallengeStatus.created,
        variant: Variant.standard,
        rated: false,
        speed: Speed.blitz,
        timeControl: ChallengeTimeControlType.clock,
        clock: (time: Duration(minutes: 5), increment: Duration.zero),
        sideChoice: SideChoice.random,
      );

      final app = await makeTestProviderScopeApp(
        tester,
        home: const _ShowConfirmDialogWidget(challenge: challenge),
      );
      await tester.pumpWidget(app);
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.textContaining('challenges you'), findsNothing);
      expect(find.text('Accept'), findsOneWidget);
      expect(find.text('Decline'), findsOneWidget);
    }, variant: kPlatformVariant);

    testWidgets('shows no title for open challenge without destUser', (tester) async {
      const challenge = Challenge(
        id: ChallengeId('H9fIRZUk'),
        status: ChallengeStatus.created,
        challenger: (
          user: LightUser(id: UserId('bot1'), name: 'Bot1', isOnline: true),
          rating: 1500,
          provisionalRating: null,
          lagRating: null,
        ),
        variant: Variant.standard,
        rated: false,
        speed: Speed.blitz,
        timeControl: ChallengeTimeControlType.clock,
        clock: (time: Duration(minutes: 5), increment: Duration.zero),
        sideChoice: SideChoice.random,
      );

      final app = await makeTestProviderScopeApp(
        tester,
        home: const _ShowConfirmDialogWidget(challenge: challenge),
      );
      await tester.pumpWidget(app);
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Bot1 challenges you: Random side • Casual • 5+0'), findsOneWidget);
      expect(find.text('Accept'), findsOneWidget);
      expect(find.text('Decline'), findsOneWidget);
    }, variant: kPlatformVariant);
  });

  group('showDeclineDialog', () {
    testWidgets('shows all decline reason options', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const _ShowDeclineDialogWidget(challengeId: ChallengeId('H9fIRZUk')),
      );
      await tester.pumpWidget(app);
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Decline'), findsOneWidget);
      expect(find.text("I'm not accepting challenges at the moment."), findsOneWidget);
      expect(
        find.text('This is not the right time for me, please ask again later.'),
        findsOneWidget,
      );
    }, variant: kPlatformVariant);

    testWidgets('calls decline on repository with selected reason', (tester) async {
      final mockChallengeRepo = MockChallengeRepository();
      when(
        () => mockChallengeRepo.decline(any(), reason: any(named: 'reason')),
      ).thenAnswer((_) async {});

      final app = await makeTestProviderScopeApp(
        tester,
        home: const _ShowDeclineDialogWidget(challengeId: ChallengeId('H9fIRZUk')),
        overrides: {
          challengeRepositoryProvider: challengeRepositoryProvider.overrideWith(
            (_) => mockChallengeRepo,
          ),
        },
      );
      await tester.pumpWidget(app);
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text("I'm not accepting challenges at the moment."));
      await tester.pumpAndSettle();

      verify(
        () => mockChallengeRepo.decline(
          const ChallengeId('H9fIRZUk'),
          reason: ChallengeDeclineReason.generic,
        ),
      ).called(1);
    }, variant: kPlatformVariant);
  });

  group('acceptChallenge', () {
    testWidgets('shows error snackbar when challenge has no gameFullId', (tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      final mockChallengeRepo = MockChallengeRepository();
      when(() => mockChallengeRepo.accept(any())).thenAnswer((_) async {});
      when(() => mockChallengeRepo.show(any())).thenAnswer(
        (_) async => const Challenge(
          id: ChallengeId('H9fIRZUk'),
          status: ChallengeStatus.created,
          variant: Variant.standard,
          rated: true,
          speed: Speed.rapid,
          timeControl: ChallengeTimeControlType.clock,
          clock: (time: Duration(seconds: 600), increment: Duration.zero),
          sideChoice: SideChoice.random,
        ),
      );

      final app = await makeTestProviderScope(
        tester,
        child: MaterialApp(
          navigatorKey: navigatorKey,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) => ElevatedButton(
                onPressed: () => ref
                    .read(challengeServiceProvider)
                    .acceptChallenge(const ChallengeId('H9fIRZUk')),
                child: const Text('Accept'),
              ),
            ),
          ),
        ),
        overrides: {
          challengeRepositoryProvider: challengeRepositoryProvider.overrideWith(
            (_) => mockChallengeRepo,
          ),
          currentNavigatorKeyProvider: currentNavigatorKeyProvider.overrideWithValue(navigatorKey),
        },
      );

      await tester.pumpWidget(app);
      await tester.tap(find.text('Accept'));
      await tester.pumpAndSettle();

      expect(find.text('Failed to accept challenge'), findsOneWidget);
    }, variant: kPlatformVariant);

    testWidgets('redirects to GameScreen on successful accept', (tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      final mockChallengeRepo = MockChallengeRepository();
      when(() => mockChallengeRepo.accept(any())).thenAnswer((_) async {});
      when(() => mockChallengeRepo.show(any())).thenAnswer(
        (_) async => const Challenge(
          id: ChallengeId('H9fIRZUk'),
          gameFullId: GameFullId('H9fIRZUkabcd'),
          status: ChallengeStatus.accepted,
          variant: Variant.standard,
          rated: true,
          speed: Speed.rapid,
          timeControl: ChallengeTimeControlType.clock,
          clock: (time: Duration(seconds: 600), increment: Duration.zero),
          sideChoice: SideChoice.random,
        ),
      );

      final app = await makeTestProviderScope(
        tester,
        child: MaterialApp(
          navigatorKey: navigatorKey,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) => ElevatedButton(
                onPressed: () => ref
                    .read(challengeServiceProvider)
                    .acceptChallenge(const ChallengeId('H9fIRZUk')),
                child: const Text('Accept'),
              ),
            ),
          ),
        ),
        overrides: {
          challengeRepositoryProvider: challengeRepositoryProvider.overrideWith(
            (_) => mockChallengeRepo,
          ),
          currentNavigatorKeyProvider: currentNavigatorKeyProvider.overrideWithValue(navigatorKey),
        },
      );

      await tester.pumpWidget(app);
      await tester.tap(find.text('Accept'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(GameScreen), findsOneWidget);
    }, variant: kPlatformVariant);
  });
}

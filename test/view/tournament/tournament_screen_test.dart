import 'package:chessground/chessground.dart' show PieceWidget;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/tournament/tournament.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/tournament/tournament_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../../model/game/game_socket_example_data.dart';
import '../../network/fake_websocket_channel.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

const kTournamentId = TournamentId('test');

const kTournament = Tournament(
  id: kTournamentId,
  createdBy: 'tom-anders',
  timeIncrement: TimeIncrement(3, 0),
  perf: Perf.blitz,
  variant: Variant.standard,
  berserkable: true,
  featuredGame: null,
  fullName: 'Test Tournament',
  description: null,
  isFinished: false,
  isStarted: true,
  timeToStart: null,
  timeToFinish: Duration(minutes: 30),
  standing: null,
  me: null,
  nbPlayers: 12,
  verdicts: (list: IList.empty(), accepted: true),
  reloadEndpoint: null,
);

StandingPlayer makeTestPlayer(int index) => StandingPlayer(
  user: LightUser(id: UserId.fromUserName('player$index'), name: 'player$index'),
  rating: 1500 + index,
  score: index,
  provisional: false,
  withdraw: index.isOdd,
  sheet: (fire: index.isEven, scores: const IList.empty()),
);

final kFirstStandingPage = (page: 1, players: Iterable.generate(10, makeTestPlayer).toIList());
final kSecondStandingPage = (
  page: 2,
  players: Iterable.generate(2, (i) => makeTestPlayer(i + 10)).toIList(),
);

class MockTournamentRepository extends Mock implements TournamentRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(kTournament);
  });

  group('Tournament screen', () {
    final isOurTestTournament = isA<Tournament>().having((t) => t.id, 'id', kTournamentId);

    testWidgets('Displays tournament data and standings', variant: kPlatformVariant, (
      WidgetTester tester,
    ) async {
      final mockRepository = MockTournamentRepository();

      when(
        () => mockRepository.getTournament(kTournament.id),
      ).thenAnswer((_) async => kTournament.copyWith(standing: kFirstStandingPage));

      when(
        () => mockRepository.reload(any(that: isOurTestTournament), standingsPage: 1),
      ).thenAnswer((_) async => kTournament.copyWith(standing: kFirstStandingPage));

      when(
        () => mockRepository.reload(any(that: isOurTestTournament), standingsPage: 2),
      ).thenAnswer((_) async => kTournament.copyWith(standing: kSecondStandingPage));

      final app = await makeTestProviderScopeApp(
        tester,
        home: const TournamentScreen(id: kTournamentId),
        overrides: [tournamentRepositoryProvider.overrideWith((ref) => mockRepository)],
      );
      await tester.pumpWidget(app);

      // Wait for tournament data to load
      await tester.pump();

      expect(find.text('Test Tournament'), findsOneWidget);

      expect(find.text('player1'), findsOneWidget);
      expect(find.text('player10'), findsNothing);

      expect(find.text('1-10 / 12'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.skip_next));
      // Wait for next page of standings to load
      await tester.pumpAndSettle();

      expect(find.text('player1'), findsNothing);
      expect(find.text('player10'), findsOneWidget);

      expect(find.text('11-12 / 12'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.first_page));
      // Wait for first page of standings to load
      await tester.pumpAndSettle();

      expect(find.text('player1'), findsOneWidget);
      expect(find.text('player10'), findsNothing);
    });

    testWidgets('Can join tournament', variant: kPlatformVariant, (WidgetTester tester) async {
      const name = 'tom-anders';
      final user = LightUser(id: UserId.fromUserName(name), name: name);
      final session = AuthSessionState(user: user, token: 'test-token');

      final mockRepository = MockTournamentRepository();
      when(
        () => mockRepository.getTournament(kTournament.id),
      ).thenAnswer((_) async => kTournament.copyWith(standing: kFirstStandingPage));

      when(() => mockRepository.join(kTournament.id)).thenAnswer((_) async {});

      const me = (rank: 11, gameId: null, withdraw: false, pauseDelay: null);
      when(
        () => mockRepository.reload(any(that: isOurTestTournament), standingsPage: 1),
      ).thenAnswer((_) async => kTournament.copyWith(standing: kFirstStandingPage, me: me));

      when(
        () => mockRepository.reload(any(that: isOurTestTournament), standingsPage: 2),
      ).thenAnswer((_) async => kTournament.copyWith(standing: kSecondStandingPage, me: me));

      final fakeSocket = FakeWebSocketChannel();
      final app = await makeTestProviderScopeApp(
        tester,
        home: const TournamentScreen(id: kTournamentId),
        userSession: session,
        overrides: [
          tournamentRepositoryProvider.overrideWith((ref) => mockRepository),
          webSocketChannelFactoryProvider.overrideWith((ref) {
            return FakeWebSocketChannelFactory((_) => fakeSocket);
          }),
        ],
      );
      await tester.pumpWidget(app);

      // Wait for tournament data to load
      await tester.pump();

      expect(find.text('Join'), findsOneWidget);

      await tester.tap(find.text('Join'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Join'), findsNothing);

      fakeSocket.addIncomingMessages(['{"t": "reload"}']);
      // Wait for reload
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Join'), findsNothing);
      expect(find.text('Pause'), findsOneWidget);

      expect(find.byIcon(LichessIcons.target), findsOneWidget);
      // We're rank 11, so this should take us to the 2nd page
      await tester.tap(find.byIcon(LichessIcons.target));

      // Wait for next page of standings to load
      await tester.pump();
      expect(find.text('11-12 / 12'), findsOneWidget);
    });

    testWidgets('Cannot join tournament if not logged in', variant: kPlatformVariant, (
      WidgetTester tester,
    ) async {
      final mockRepository = MockTournamentRepository();
      when(
        () => mockRepository.getTournament(kTournament.id),
      ).thenAnswer((_) async => kTournament.copyWith(standing: kFirstStandingPage));

      const me = (rank: 11, gameId: null, withdraw: false, pauseDelay: null);
      when(
        () => mockRepository.reload(any(that: isOurTestTournament), standingsPage: 1),
      ).thenAnswer((_) async => kTournament.copyWith(standing: kFirstStandingPage, me: me));

      when(
        () => mockRepository.reload(any(that: isOurTestTournament), standingsPage: 2),
      ).thenAnswer((_) async => kTournament.copyWith(standing: kSecondStandingPage, me: me));

      final app = await makeTestProviderScopeApp(
        tester,
        home: const TournamentScreen(id: kTournamentId),
        overrides: [tournamentRepositoryProvider.overrideWith((ref) => mockRepository)],
      );
      await tester.pumpWidget(app);

      // Wait for tournament data to load
      await tester.pump();

      expect(find.text('Sign in'), findsOneWidget);
      expect(find.text('Join'), findsNothing);

      await tester.tap(find.text('Sign in'));
      await tester.pump();

      verifyNever(() => mockRepository.join(any()));
    });

    testWidgets(
      'Cannot join tournament if not meeting entry conditions',
      variant: kPlatformVariant,
      (WidgetTester tester) async {
        const name = 'tom-anders';
        final user = LightUser(id: UserId.fromUserName(name), name: name);
        final session = AuthSessionState(user: user, token: 'test-token');

        final mockRepository = MockTournamentRepository();
        when(() => mockRepository.getTournament(kTournament.id)).thenAnswer(
          (_) async => kTournament.copyWith(
            standing: kFirstStandingPage,
            verdicts: (
              list:
                  [
                    (condition: 'condition1', ok: true),
                    (condition: 'condition2', ok: false),
                  ].toIList(),
              accepted: false,
            ),
          ),
        );

        final fakeSocket = FakeWebSocketChannel();
        final app = await makeTestProviderScopeApp(
          tester,
          home: const TournamentScreen(id: kTournamentId),
          userSession: session,
          overrides: [
            tournamentRepositoryProvider.overrideWith((ref) => mockRepository),
            webSocketChannelFactoryProvider.overrideWith((ref) {
              return FakeWebSocketChannelFactory((_) => fakeSocket);
            }),
          ],
        );
        await tester.pumpWidget(app);

        // Wait for tournament data to load
        await tester.pump();

        expect(find.text('Join'), findsOneWidget);

        expect(find.text('condition1'), findsOneWidget);
        expect(find.text('condition2'), findsOneWidget);

        await tester.tap(find.text('Join'));
        await tester.pump();

        verifyNever(() => mockRepository.join(any()));
      },
    );

    testWidgets('Opens game screen when there is a new pairing', variant: kPlatformVariant, (
      WidgetTester tester,
    ) async {
      const name = 'tom-anders';
      final user = LightUser(id: UserId.fromUserName(name), name: name);
      final session = AuthSessionState(user: user, token: 'test-token');

      const pairingGameId = GameFullId('1234567890ab');

      final mockRepository = MockTournamentRepository();

      when(() => mockRepository.getTournament(kTournament.id)).thenAnswer(
        (_) async =>
            kTournament.copyWith(me: (rank: 11, gameId: null, withdraw: false, pauseDelay: null)),
      );

      final fakeTournamentSocket = FakeWebSocketChannel();
      final fakeGameSocket = FakeWebSocketChannel();
      final app = await makeTestProviderScopeApp(
        tester,
        home: const TournamentScreen(id: kTournamentId),
        userSession: session,
        overrides: [
          tournamentRepositoryProvider.overrideWith((ref) => mockRepository),
          webSocketChannelFactoryProvider.overrideWith((ref) {
            return FakeWebSocketChannelFactory((String url) {
              final uri = Uri.parse(url);
              switch (uri.path) {
                case '/tournament/$kTournamentId/socket/v6':
                  return fakeTournamentSocket;
                case '/play/$pairingGameId/v6':
                  return fakeGameSocket;
                default:
                  throw Exception('Unexpected URL: $url');
              }
            });
          }),
        ],
      );
      await tester.pumpWidget(app);

      // Wait for tournament data to load
      await tester.pump();

      // Pretend we have a new game
      when(
        () => mockRepository.reload(any(that: isOurTestTournament), standingsPage: 1),
      ).thenAnswer(
        (_) async => kTournament.copyWith(
          me: (rank: 11, gameId: pairingGameId, withdraw: false, pauseDelay: null),
        ),
      );
      fakeTournamentSocket.addIncomingMessages(['{"t": "reload"}']);
      // Wait for reload
      await tester.pump();

      // Wait for game screen to load
      await tester.pump();

      expect(find.byType(GameScreen), findsOneWidget);
      await fakeGameSocket.connectionEstablished;
      fakeGameSocket.addIncomingMessages([
        makeFullEvent(
          pairingGameId.gameId,
          '',
          whiteUserName: session.user.name,
          blackUserName: 'Steven',
        ),
      ]);
      // wait for socket message
      await tester.pump(const Duration(milliseconds: 10));
      expect(find.byType(PieceWidget), findsNWidgets(32));
    });
  });
}

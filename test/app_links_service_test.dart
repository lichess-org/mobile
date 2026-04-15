import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/app_links_service.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_results_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_round_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/view/study/study_screen.dart';
import 'package:lichess_mobile/src/view/tournament/tournament_screen.dart';
import 'package:lichess_mobile/src/view/watch/tv_screen.dart';
import 'package:mocktail/mocktail.dart';

import 'example_data.dart';
import 'model/game/game_socket_example_data.dart';
import 'model/puzzle/mock_server_responses.dart';
import 'network/fake_http_client_factory.dart';
import 'network/fake_websocket_channel.dart';
import 'test_provider_scope.dart';

// Mock response for a cached widget puzzle with a different id than the daily.
// Built from the daily mock data to share the same valid game/pgn structure.
final _mockStalePuzzleJson = mockDailyPuzzleResponse.trim().replaceFirst(
  '"id":"0XqV2"',
  '"id":"stale1"',
);

class MockGameRepository extends Mock implements GameRepository {}

class MockChallengeRepository extends Mock implements ChallengeRepository {}

class _DailyPuzzleLinkTestWidget extends ConsumerWidget {
  const _DailyPuzzleLinkTestWidget({this.puzzleId});

  final String? puzzleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        await ref.read(appLinksServiceProvider).handleDailyPuzzleLink(context, puzzleId);
      },
      child: const Text('test daily link'),
    );
  }
}

class _TestWidget extends ConsumerWidget {
  const _TestWidget({required this.uri});

  final Uri uri;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        await ref.read(appLinksServiceProvider).start();
        await ref.read(appLinksServiceProvider).handleAppLink(context, uri);
      },
      child: const Text('test link'),
    );
  }
}

Future<void> triggerAppLink(
  WidgetTester tester,
  Uri appLinkUri, {
  Map<ProviderOrFamily, Override>? overrides,
}) async {
  final app = await makeTestProviderScopeApp(
    tester,
    overrides: overrides,
    home: _TestWidget(uri: appLinkUri),
  );
  await tester.pumpWidget(app);
  await tester.tap(find.text('test link'));
}

Future<void> triggerDailyPuzzleLink(
  WidgetTester tester,
  String? puzzleId, {
  Map<ProviderOrFamily, Override>? overrides,
}) async {
  final app = await makeTestProviderScopeApp(
    tester,
    overrides: overrides,
    home: _DailyPuzzleLinkTestWidget(puzzleId: puzzleId),
  );
  await tester.pumpWidget(app);
  await tester.tap(find.text('test daily link'));
}

void main() {
  group('handleDailyPuzzleLink', () {
    // Builds an httpClientFactoryProvider override whose mock client routes
    // puzzle API endpoints to controlled responses.
    Override puzzleHttpOverride({bool failStaleFetch = false}) {
      return httpClientFactoryProvider.overrideWith((ref) {
        return FakeHttpClientFactory(
          () => MockClient((request) async {
            if (request.url.path == '/api/puzzle/daily') {
              return http.Response(mockDailyPuzzleResponse.trim(), 200);
            }
            if (request.url.path == '/api/puzzle/stale1') {
              if (failStaleFetch) return http.Response('Server error', 500);
              return http.Response(_mockStalePuzzleJson, 200);
            }
            return http.Response('', 200);
          }),
        );
      });
    }

    testWidgets("no puzzle id: opens today's daily puzzle", (tester) async {
      await triggerDailyPuzzleLink(
        tester,
        null,
        overrides: {httpClientFactoryProvider: puzzleHttpOverride()},
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget(find.byType(PuzzleScreen)),
        isA<PuzzleScreen>()
            .having((s) => s.puzzle?.puzzle.id, 'puzzle id', const PuzzleId('0XqV2'))
            .having((s) => s.puzzle?.isDailyPuzzle, 'is daily', true),
      );
    });

    testWidgets('puzzle id matches daily: opens daily puzzle without extra fetch', (tester) async {
      // PuzzleRepository.fetch() does not set isDailyPuzzle, so if puzzleProvider
      // were called (wrongly) the assertion on isDailyPuzzle: true would fail.
      await triggerDailyPuzzleLink(
        tester,
        '0XqV2', // same id as the daily puzzle
        overrides: {httpClientFactoryProvider: puzzleHttpOverride()},
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget(find.byType(PuzzleScreen)),
        isA<PuzzleScreen>()
            .having((s) => s.puzzle?.puzzle.id, 'puzzle id', const PuzzleId('0XqV2'))
            .having((s) => s.puzzle?.isDailyPuzzle, 'is daily', true),
      );
    });

    testWidgets('puzzle id differs from daily: opens specific puzzle not flagged as daily', (
      tester,
    ) async {
      await triggerDailyPuzzleLink(
        tester,
        'stale1',
        overrides: {httpClientFactoryProvider: puzzleHttpOverride()},
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget(find.byType(PuzzleScreen)),
        isA<PuzzleScreen>()
            .having((s) => s.puzzle?.puzzle.id, 'puzzle id', const PuzzleId('stale1'))
            .having((s) => s.puzzle?.isDailyPuzzle, 'is daily', isNot(true)),
      );
    });

    testWidgets('puzzle id differs from daily and fetch fails: falls back to daily puzzle', (
      tester,
    ) async {
      await triggerDailyPuzzleLink(
        tester,
        'stale1',
        overrides: {httpClientFactoryProvider: puzzleHttpOverride(failStaleFetch: true)},
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget(find.byType(PuzzleScreen)),
        isA<PuzzleScreen>()
            .having((s) => s.puzzle?.puzzle.id, 'puzzle id', const PuzzleId('0XqV2'))
            .having((s) => s.puzzle?.isDailyPuzzle, 'is daily', true),
      );
    });

    testWidgets('replaces existing PuzzleScreen instead of stacking a duplicate', (tester) async {
      AppLinksService? capturedService;
      BuildContext? capturedContext;

      final app = await makeTestProviderScopeApp(
        tester,
        overrides: {httpClientFactoryProvider: puzzleHttpOverride()},
        home: Consumer(
          builder: (context, ref, _) {
            capturedService = ref.read(appLinksServiceProvider);
            capturedContext = context;
            return ElevatedButton(
              onPressed: () async {
                await ref.read(appLinksServiceProvider).handleDailyPuzzleLink(context, null);
              },
              child: const Text('go to puzzle'),
            );
          },
        ),
      );
      await tester.pumpWidget(app);

      // First tap: pushes PuzzleScreen.
      await tester.tap(find.text('go to puzzle'));
      await tester.pumpAndSettle();
      expect(find.byType(PuzzleScreen), findsOneWidget);

      // Second call from the home context (still mounted below PuzzleScreen):
      // should replace rather than push. Fire-and-forget: the push future only
      // resolves when the route is popped, so we drive it via pumpAndSettle.
      unawaited(capturedService!.handleDailyPuzzleLink(capturedContext!, null));
      await tester.pumpAndSettle();

      // Pressing back must return to the home widget — no extra PuzzleScreen in the stack.
      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.text('go to puzzle'), findsOneWidget);
      expect(find.byType(PuzzleScreen), findsNothing);
    });
  });

  group('resolveAppLinkUri', () {
    testWidgets('Nothing happens for an empty path', (WidgetTester tester) async {
      final uri = Uri.parse('https://lichess.org/');
      await triggerAppLink(tester, uri);
      await tester.pumpAndSettle(); // Wait for any navigation to complete
      expect(find.text('test link'), findsOneWidget); // Still on the same screen
    });

    testWidgets('resolves /study/{id} to StudyScreen route', (WidgetTester tester) async {
      final uri = Uri.parse('https://lichess.org/study/p9uY0321');
      await triggerAppLink(tester, uri);
      await tester.pumpAndSettle(); // Wait study screen to load
      expect(
        tester.widget(find.byType(StudyScreen)),
        isA<StudyScreen>()
            .having((s) => s.options.id, 'id', 'p9uY0321')
            .having((s) => s.options.initialChapter, 'initialChapter', isNull),
      );
    });

    testWidgets('resolves /study/{id}/{chapter} to StudyScreen route with initial chapter', (
      WidgetTester tester,
    ) async {
      final uri = Uri.parse('https://lichess.org/study/p9uY0321/abcd1234');
      await triggerAppLink(tester, uri);
      await tester.pumpAndSettle(); // Wait study screen to load
      expect(
        tester.widget(find.byType(StudyScreen)),
        isA<StudyScreen>()
            .having((s) => s.options.id, 'id', 'p9uY0321')
            .having((s) => s.options.initialChapter, 'initialChapter', 'abcd1234'),
      );
    });

    testWidgets('resolves /training/{id} to PuzzleScreen route', (WidgetTester tester) async {
      final uri = Uri.parse('https://lichess.org/training/61044');
      await triggerAppLink(tester, uri);
      await tester.pumpAndSettle(); // Wait puzzle screen to load
      expect(
        tester.widget(find.byType(PuzzleScreen)),
        isA<PuzzleScreen>().having((s) => s.puzzleId, 'id', '61044'),
      );
    });

    testWidgets('resolves /tournament/{id} to TournamentScreen route', (WidgetTester tester) async {
      final uri = Uri.parse('https://lichess.org/tournament/61044');
      await triggerAppLink(tester, uri);
      await tester.pumpAndSettle(); // Wait tournament screen to load
      expect(
        tester.widget(find.byType(TournamentScreen)),
        isA<TournamentScreen>().having((s) => s.id, 'id', '61044'),
      );
    });

    testWidgets('resolves /broadcast/.../{roundId}#players to players tab', (
      WidgetTester tester,
    ) async {
      final uri = Uri.parse(
        'https://lichess.org/broadcast/grenke-chess-festival-2026--freestyle-open-a/round-3/ioIYmuar#players',
      );
      await triggerAppLink(tester, uri);
      await tester.pumpAndSettle();

      expect(
        tester.widget(find.byType(BroadcastRoundScreenLoading)),
        isA<BroadcastRoundScreenLoading>()
            .having((s) => s.roundId, 'id', 'ioIYmuar')
            .having((s) => s.initialTab, 'initialTab', BroadcastRoundTab.players),
      );
    });

    testWidgets('resolves /broadcast/.../{roundId}#players/{playerId} to player results screen', (
      WidgetTester tester,
    ) async {
      final uri = Uri.parse(
        'https://lichess.org/broadcast/grenke-chess-festival-2026--freestyle-open-a/round-3/ioIYmuar#players/250511',
      );
      await triggerAppLink(tester, uri);
      await tester.pumpAndSettle();

      // Top of stack: player results screen
      expect(
        tester.widget(find.byType(BroadcastPlayerResultsScreenLoading)),
        isA<BroadcastPlayerResultsScreenLoading>()
            .having((s) => s.roundId, 'id', 'ioIYmuar')
            .having((s) => s.playerId, 'id', '250511'),
      );

      // Back navigates to the round screen on the players tab
      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(
        tester.widget(find.byType(BroadcastRoundScreenLoading)),
        isA<BroadcastRoundScreenLoading>()
            .having((s) => s.roundId, 'id', 'ioIYmuar')
            .having((s) => s.initialTab, 'initialTab', BroadcastRoundTab.players),
      );
    });

    testWidgets(
      'resolves /broadcast/.../{roundId}#players/{playerId} with percent-encoded non-FIDE playerId',
      (WidgetTester tester) async {
        // Players without a FIDE ID use their name as playerId in the URL fragment
        final uri = Uri.parse(
          'https://lichess.org/broadcast/tcec-s29-leagues--superfinal/match/RSIGxDYD#players/Stockfish%20dev-20260318-d173a065',
        );
        await triggerAppLink(tester, uri);
        await tester.pumpAndSettle();

        expect(
          tester.widget(find.byType(BroadcastPlayerResultsScreenLoading)),
          isA<BroadcastPlayerResultsScreenLoading>()
              .having((s) => s.roundId, 'id', 'RSIGxDYD')
              .having((s) => s.playerId, 'id', 'Stockfish dev-20260318-d173a065'),
        );

        await tester.pageBack();
        await tester.pumpAndSettle();

        expect(
          tester.widget(find.byType(BroadcastRoundScreenLoading)),
          isA<BroadcastRoundScreenLoading>()
              .having((s) => s.roundId, 'id', 'RSIGxDYD')
              .having((s) => s.initialTab, 'initialTab', BroadcastRoundTab.players),
        );
      },
    );

    testWidgets('resolves /broadcast/.../{roundId}/{gameId} to two routes (stacking)', (
      WidgetTester tester,
    ) async {
      // Broadcast URLs have many segments: /broadcast/slug/name/roundId/gameId
      final uri = Uri.parse(
        'https://lichess.org/broadcast/candidates-2024/round-1/abcde123/zxcvb456',
      );
      await triggerAppLink(tester, uri);
      await tester.pumpAndSettle(); // Wait for navigation to complete

      expect(
        tester.widget(find.byType(BroadcastGameScreen)),
        isA<BroadcastGameScreen>().having((s) => s.gameId, 'id', 'zxcvb456'),
      );

      await tester.pageBack(); // Should have pushed round screen first, game screen on top of it
      await tester.pumpAndSettle(); // Wait for navigation to complete

      expect(
        tester.widget(find.byType(BroadcastRoundScreenLoading)),
        isA<BroadcastRoundScreenLoading>().having((s) => s.roundId, 'id', 'abcde123'),
      );
    });

    final finishedGame = generateExportedGames(count: 1).first.copyWith(status: GameStatus.draw);

    testWidgets('resolves /gameid link for finished game', (WidgetTester tester) async {
      // lichess.org/gameid -> Opens analysis at the first move
      final uri = Uri.parse('https://lichess.org/${finishedGame.id.value}');
      final mockGameRepository = MockGameRepository();
      when(() => mockGameRepository.getGame(finishedGame.id)).thenAnswer((_) async => finishedGame);

      await triggerAppLink(
        tester,
        uri,
        overrides: {
          gameRepositoryProvider: gameRepositoryProvider.overrideWith((_) => mockGameRepository),
        },
      );
      await tester.pumpAndSettle(); // Wait analysis screen to load

      expect(
        tester.widget(find.byType(AnalysisScreen)),
        isA<AnalysisScreen>()
            .having((s) => s.options.gameId, 'id', finishedGame.id.value)
            .having((s) => s.options.initialMoveCursor, 'move number', 0),
      );
    });

    testWidgets('resolves /gameid link for finished game with ply fragment', (
      WidgetTester tester,
    ) async {
      // lichess.org/gameid#20 -> Opens analysis at move 20
      final uri = Uri.parse('https://lichess.org/${finishedGame.id.value}#20');
      final mockGameRepository = MockGameRepository();
      when(() => mockGameRepository.getGame(finishedGame.id)).thenAnswer((_) async => finishedGame);

      await triggerAppLink(
        tester,
        uri,
        overrides: {
          gameRepositoryProvider: gameRepositoryProvider.overrideWith((_) => mockGameRepository),
        },
      );
      await tester.pumpAndSettle(); // Wait for analysis screen to load

      expect(
        tester.widget(find.byType(AnalysisScreen)),
        isA<AnalysisScreen>()
            .having((s) => s.options.gameId, 'id', finishedGame.id.value)
            .having((s) => s.options.initialMoveCursor, 'move number', 20),
      );
    });

    testWidgets('resolves /gameid/black finished game link', (WidgetTester tester) async {
      final uri = Uri.parse('https://lichess.org/${finishedGame.id.value}/black');
      final mockGameRepository = MockGameRepository();
      when(() => mockGameRepository.getGame(finishedGame.id)).thenAnswer((_) async => finishedGame);

      await triggerAppLink(
        tester,
        uri,
        overrides: {
          gameRepositoryProvider: gameRepositoryProvider.overrideWith((_) => mockGameRepository),
        },
      );
      await tester.pumpAndSettle(); // Wait for analysis screen to load

      expect(
        tester.widget(find.byType(AnalysisScreen)),
        isA<AnalysisScreen>()
            .having((s) => s.options.gameId, 'id', finishedGame.id.value)
            .having((s) => s.options.orientation, 'player color', Side.black),
      );
    });

    testWidgets('resolves /gameid link for ongoing game', (WidgetTester tester) async {
      final mockGameRepository = MockGameRepository();
      final ongoingGame = generateExportedGames(count: 1).first.copyWith(
        status: GameStatus.started,
        black: const Player(
          user: LightUser(id: UserId('blackId'), name: 'Black'),
        ),
        white: const Player(
          user: LightUser(id: UserId('whiteId'), name: 'White'),
        ),
      );
      when(() => mockGameRepository.getGame(ongoingGame.id)).thenAnswer((_) async => ongoingGame);

      final uri = Uri.parse('https://lichess.org/${ongoingGame.id.value}');

      await triggerAppLink(
        tester,
        uri,
        overrides: {
          gameRepositoryProvider: gameRepositoryProvider.overrideWith((_) => mockGameRepository),
        },
      );

      await tester.pump(kFakeWebSocketConnectionLag);

      sendServerSocketMessages(Uri(path: '/watch/${ongoingGame.id.value}/white/v6'), [
        makeFullEvent(
          ongoingGame.id,
          '',
          whiteUserName: ongoingGame.white.user!.name,
          blackUserName: ongoingGame.black.user!.name,
        ),
      ]);
      await tester.pump(); // Process socket message

      await tester.pumpAndSettle(); // Wait for TV screen to load

      expect(
        tester.widget(find.byType(TvScreen)),
        isA<TvScreen>().having((s) => s.initialGame?.$1, 'id', ongoingGame.id),
      );
    });

    testWidgets('replaces existing screen instead of stacking a duplicate', (tester) async {
      AppLinksService? capturedService;
      BuildContext? capturedContext;

      final uri = Uri.parse('https://lichess.org/training/61044');

      final app = await makeTestProviderScopeApp(
        tester,
        home: Consumer(
          builder: (context, ref, _) {
            capturedService = ref.read(appLinksServiceProvider);
            capturedContext = context;
            return ElevatedButton(
              onPressed: () async {
                await ref.read(appLinksServiceProvider).handleAppLink(context, uri);
              },
              child: const Text('go to puzzle'),
            );
          },
        ),
      );
      await tester.pumpWidget(app);

      // First tap: pushes PuzzleScreen.
      await tester.tap(find.text('go to puzzle'));
      await tester.pumpAndSettle();
      expect(find.byType(PuzzleScreen), findsOneWidget);

      // Second call from the home context (still mounted below PuzzleScreen):
      // should replace rather than push. Fire-and-forget: the push future only
      // resolves when the route is popped, so we drive it via pumpAndSettle.
      unawaited(capturedService!.handleAppLink(capturedContext!, uri));
      await tester.pumpAndSettle();

      // Pressing back must return to the home widget — no extra PuzzleScreen in the stack.
      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.text('go to puzzle'), findsOneWidget);
      expect(find.byType(PuzzleScreen), findsNothing);
    });

    testWidgets('resolves /challengeId link for open challenge', (WidgetTester tester) async {
      const challenge = Challenge(
        id: ChallengeId('abcdefgh'),
        challenger: (
          user: LightUser(id: UserId('thibault'), name: 'Thibault'),
          rating: 3000,
          provisionalRating: null,
          lagRating: null,
        ),
        status: ChallengeStatus.created,
        variant: Variant.standard,
        speed: Speed.blitz,
        timeControl: ChallengeTimeControlType.clock,
        clock: (increment: Duration.zero, time: Duration(minutes: 5)),
        rated: true,
        sideChoice: SideChoice.white,
      );
      final uri = Uri.parse('https://lichess.org/${challenge.id.value}');
      final mockChallengeRepository = MockChallengeRepository();
      when(() => mockChallengeRepository.show(challenge.id)).thenAnswer((_) async => challenge);

      await triggerAppLink(
        tester,
        uri,
        overrides: {
          challengeRepositoryProvider: challengeRepositoryProvider.overrideWith(
            (_) => mockChallengeRepository,
          ),
        },
      );
      await tester.pumpAndSettle(); // Wait for challenge screen to load

      expect(find.text('Thibault challenges you: ♚ Black • Rated • 5+0'), findsOneWidget);
      expect(find.text('Accept'), findsOneWidget);
      // challenges from link cannot be declined
      expect(find.text('Cancel'), findsOneWidget);
    });
  });
}

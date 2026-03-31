import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
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
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_round_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/view/study/study_screen.dart';
import 'package:lichess_mobile/src/view/tournament/tournament_screen.dart';
import 'package:lichess_mobile/src/view/watch/tv_screen.dart';
import 'package:mocktail/mocktail.dart';

import 'example_data.dart';
import 'model/game/game_socket_example_data.dart';
import 'network/fake_websocket_channel.dart';
import 'test_provider_scope.dart';

class MockGameRepository extends Mock implements GameRepository {}

class MockChallengeRepository extends Mock implements ChallengeRepository {}

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

void main() {
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
        isA<StudyScreen>().having((s) => s.id, 'id', 'p9uY0321'),
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

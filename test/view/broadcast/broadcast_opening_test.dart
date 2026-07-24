import 'package:dartchess/dartchess.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/analysis/opening_service.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';

import '../../model/analysis/fake_opening_service.dart';
import '../../model/broadcast/example_data.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

const _tournamentId = BroadcastTournamentId('RAIoMC7L');
const _roundId = BroadcastRoundId('6VuqTjes');
const _gameId = BroadcastGameId('OpeningTest');

String _epd(Position pos) => pos.fen.split(' ').take(4).join(' ');

const _kingsPawnGame = FullOpening(
  eco: 'C20',
  name: "King's Pawn Game",
  fen: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3',
  pgnMoves: 'e4',
  uciMoves: 'e2e4',
);

const _openGame = FullOpening(
  eco: 'C20',
  name: 'Open Game',
  fen: 'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6',
  pgnMoves: 'e4 e5',
  uciMoves: 'e2e4 e7e5',
);

MockClient _client(String pgn) => MockClient((request) {
  if (request.url.path == '/api/broadcast/-/-/$_roundId') {
    return mockResponse(
      broadcastRoundMockResponses[(_tournamentId, _roundId)]!,
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }
  if (request.url.path == '/api/study/$_roundId/$_gameId.pgn') {
    return mockResponse(pgn, 200, headers: {'content-type': 'application/x-chess-pgn'});
  }
  return mockResponse('', 404);
});

void main() {
  final afterE4Epd = _epd(Chess.initial.playUnchecked(Move.parse('e2e4')!));
  final afterE5Epd = _epd(
    Chess.initial.playUnchecked(Move.parse('e2e4')!).playUnchecked(Move.parse('e7e5')!),
  );

  BroadcastAnalysisState readState(WidgetTester tester) {
    final container = ProviderScope.containerOf(tester.element(find.byType(BroadcastGameScreen)));
    return container
        .read(broadcastAnalysisControllerProvider((roundId: _roundId, gameId: _gameId)))
        .requireValue;
  }

  group('Broadcast opening detection', () {
    testWidgets('opening is set when navigating to a mainline position', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const BroadcastGameScreen(
          tournamentId: _tournamentId,
          roundId: _roundId,
          gameId: _gameId,
        ),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(_client('1. e4 e5 2. Nf3'), ref),
          ),
          openingServiceProvider: openingServiceProvider.overrideWithValue(
            FakeOpeningService(openings: {afterE4Epd: _kingsPawnGame, afterE5Epd: _openGame}),
          ),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Broadcast starts at the end of the mainline (after Nf3). Navigate back to e5.
      await tester.tap(find.byKey(const ValueKey('goto-previous')));
      await tester.pumpAndSettle();
      expect(readState(tester).currentBranchOpening?.name, 'Open Game');

      // Navigate back to e4.
      await tester.tap(find.byKey(const ValueKey('goto-previous')));
      await tester.pumpAndSettle();
      expect(readState(tester).currentBranchOpening?.name, "King's Pawn Game");
    });

    testWidgets('ancestor opening is used when current node has no direct opening', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const BroadcastGameScreen(
          tournamentId: _tournamentId,
          roundId: _roundId,
          gameId: _gameId,
        ),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith(
            (ref) => LichessClient(_client('1. e4 e5 2. Nf3'), ref),
          ),
          openingServiceProvider: openingServiceProvider.overrideWithValue(
            FakeOpeningService(
              openings: {
                afterE4Epd: _kingsPawnGame,
                afterE5Epd: _openGame,
                // No opening for the Nf3 position — intentionally omitted.
              },
            ),
          ),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // At end of mainline (after Nf3): no direct opening, but the e5 ancestor
      // has 'Open Game'.
      expect(readState(tester).currentBranchOpening?.name, 'Open Game');
    });
  });
}

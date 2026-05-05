import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/opening_service.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';

import '../../model/analysis/fake_opening_service.dart';
import '../../test_provider_scope.dart';

String _epd(Position pos) => pos.fen.split(' ').take(4).join(' ');

const _kingsOpeningGame = FullOpening(
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

void main() {
  // EPD (first 4 fields of FEN) for known positions.
  // Used to configure FakeOpeningService, which matches on EPD.
  final afterE4Epd = _epd(Chess.initial.playUnchecked(Move.parse('e2e4')!));
  final afterE5Epd = _epd(
    Chess.initial.playUnchecked(Move.parse('e2e4')!).playUnchecked(Move.parse('e7e5')!),
  );

  const options = AnalysisOptions.pgn(
    id: StringId('test-opening'),
    orientation: Side.white,
    pgn: '1. e4 e5 2. Nf3',
    isComputerAnalysisAllowed: false,
    variant: Variant.standard,
  );

  AnalysisState readState(WidgetTester tester) {
    final container = ProviderScope.containerOf(tester.element(find.byType(AnalysisScreen)));
    return container.read(analysisControllerProvider(options)).requireValue;
  }

  group('Analysis opening detection', () {
    testWidgets('opening is set when navigating to a mainline position', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const AnalysisScreen(options: options),
        overrides: {
          openingServiceProvider: openingServiceProvider.overrideWithValue(
            FakeOpeningService(openings: {afterE4Epd: _kingsOpeningGame, afterE5Epd: _openGame}),
          ),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Starts at end of mainline (after Nf3). Navigate back to after e5.
      await tester.tap(find.byKey(const Key('goto-previous')));
      await tester.pumpAndSettle();

      expect(readState(tester).currentBranchOpening?.name, 'Open Game');
    });

    testWidgets('ancestor opening is used when current node has no direct opening', (tester) async {
      // The Nf3 position has no opening in the service. The e5 ancestor does.
      // _nodeOpeningAt walks up the path and returns the nearest ancestor opening.
      final app = await makeTestProviderScopeApp(
        tester,
        home: const AnalysisScreen(options: options),
        overrides: {
          openingServiceProvider: openingServiceProvider.overrideWithValue(
            FakeOpeningService(
              openings: {
                afterE4Epd: _kingsOpeningGame,
                afterE5Epd: _openGame,
                // No opening for the Nf3 position — intentionally omitted.
              },
            ),
          ),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // At end of mainline (after Nf3): no direct opening, but e5 ancestor has 'Open Game'.
      expect(readState(tester).currentBranchOpening?.name, 'Open Game');
    });

    testWidgets('opening updates correctly when navigating forward and backward', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const AnalysisScreen(options: options),
        overrides: {
          openingServiceProvider: openingServiceProvider.overrideWithValue(
            FakeOpeningService(openings: {afterE4Epd: _kingsOpeningGame, afterE5Epd: _openGame}),
          ),
        },
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // At Nf3: ancestor (e5) opening.
      expect(readState(tester).currentBranchOpening?.name, 'Open Game');

      // Navigate back to e5.
      await tester.tap(find.byKey(const Key('goto-previous')));
      await tester.pumpAndSettle();
      expect(readState(tester).currentBranchOpening?.name, 'Open Game');

      // Navigate back to e4.
      await tester.tap(find.byKey(const Key('goto-previous')));
      await tester.pumpAndSettle();
      expect(readState(tester).currentBranchOpening?.name, "King's Pawn Game");

      // Navigate forward to e5.
      await tester.tap(find.byKey(const Key('goto-next')));
      await tester.pumpAndSettle();
      expect(readState(tester).currentBranchOpening?.name, 'Open Game');
    });
  });
}

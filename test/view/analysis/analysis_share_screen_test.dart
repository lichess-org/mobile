import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_share_screen.dart';

import '../../test_provider_scope.dart';

void main() {
  const options = AnalysisOptions.pgn(
    id: StringId('test_share'),
    orientation: Side.white,
    pgn: '1. e4 *',
    isComputerAnalysisAllowed: false,
    variant: Variant.standard,
  );

  tearDown(() {
    clearSavedStandaloneAnalysis();
  });

  group('AnalysisShareScreen', () {
    testWidgets('last edited PGN header is saved on share', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const AnalysisShareScreen(options: options),
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Find the BlackElo text field by its label
      final blackEloLabel = find.text('BlackElo');
      expect(blackEloLabel, findsOneWidget);

      // The TextField is a sibling of the label inside a Row
      final blackEloRow = find.ancestor(of: blackEloLabel, matching: find.byType(Row));
      final blackEloField = find.descendant(of: blackEloRow, matching: find.byType(TextField));
      expect(blackEloField, findsOneWidget);

      // Enter a value without leaving the field
      await tester.tap(blackEloField);
      await tester.enterText(blackEloField, '2400');
      await tester.pump();

      // Tap the Share button while BlackElo still has focus
      await tester.tap(find.text('Share PGN'));
      await tester.pump();

      // Verify the state has the updated BlackElo (not "?")
      final container = ProviderScope.containerOf(tester.element(find.byType(AnalysisShareScreen)));
      final headers = container.read(analysisControllerProvider(options)).requireValue.pgnHeaders;
      expect(headers['BlackElo'], '2400');
    });

    testWidgets('WhiteElo is also saved when it is the last edited field', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const AnalysisShareScreen(options: options),
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final whiteEloLabel = find.text('WhiteElo');
      final whiteEloRow = find.ancestor(of: whiteEloLabel, matching: find.byType(Row));
      final whiteEloField = find.descendant(of: whiteEloRow, matching: find.byType(TextField));

      await tester.tap(whiteEloField);
      await tester.enterText(whiteEloField, '1800');
      await tester.pump();

      await tester.tap(find.text('Share PGN'));
      await tester.pump();

      final container = ProviderScope.containerOf(tester.element(find.byType(AnalysisShareScreen)));
      final headers = container.read(analysisControllerProvider(options)).requireValue.pgnHeaders;
      expect(headers['WhiteElo'], '1800');
    });
  });
}

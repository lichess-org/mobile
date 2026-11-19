import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/widgets/game_summary_table.dart';
import 'package:material_ui/material_ui.dart';

import '../test_provider_scope.dart';

void main() {
  testWidgets('dims zero error counts independently for each player', (tester) async {
    final app = await makeTestProviderScopeApp(
      tester,
      home: const Scaffold(
        body: GameSummaryTable(
          pgnHeaders: IMapConst({}),
          playersAnalysis: (
            white: PlayerAnalysis(inaccuracies: 0, mistakes: 2, blunders: 0),
            black: PlayerAnalysis(inaccuracies: 1, mistakes: 0, blunders: 3),
          ),
        ),
      ),
    );
    await tester.pumpWidget(app);

    final zeroCounts = find.text('0');
    expect(zeroCounts, findsNWidgets(3));
    for (final element in zeroCounts.evaluate()) {
      final defaultColor = DefaultTextStyle.of(element).style.color!;
      expect((element.widget as Text).style?.color, defaultColor.withValues(alpha: 0.7));
    }
    expect(tester.widget<Text>(find.text('1')).style?.color, LichessColors.inaccuracy);
    expect(tester.widget<Text>(find.text('2')).style?.color, LichessColors.mistake);
    expect(tester.widget<Text>(find.text('3')).style?.color, LichessColors.blunder);
  });
}

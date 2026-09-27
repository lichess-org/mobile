import 'package:dartchess/dartchess.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/game/game_filter.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  group('GameFilterState.count', () {
    test('counts the result filter', () {
      expect(const GameFilterState().count, 0);
      expect(const GameFilterState(result: GameResultFilter.won).count, 1);
      expect(const GameFilterState(side: Side.white, result: GameResultFilter.won).count, 2);
    });
  });

  group('GameFilterState.selectionLabel', () {
    test('shows Won when only the result filter is set', () {
      expect(const GameFilterState(result: GameResultFilter.won).selectionLabel(l10n), 'Won');
    });

    test('combines with other filters', () {
      expect(
        const GameFilterState(side: Side.white, result: GameResultFilter.won).selectionLabel(l10n),
        'White, Won',
      );
    });

    test('falls back to the all games label when nothing is set', () {
      expect(const GameFilterState().selectionLabel(l10n), l10n.mobileAllGames);
    });
  });
}

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/game/game_filter.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

import '../../test_container.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  group('GameFilterState.count', () {
    test('counts the result filter', () {
      expect(const GameFilterState().count, 0);
      expect(const GameFilterState(result: GameResultFilter.won).count, 1);
      expect(const GameFilterState(side: Side.white, result: GameResultFilter.won).count, 2);
      expect(
        GameFilterState(
          perfs: {Perf.blitz}.lock,
          side: Side.white,
          result: GameResultFilter.won,
        ).count,
        3,
      );
    });
  });

  group('GameFilterState.selectionLabel', () {
    test('shows Won when only the result filter is set', () {
      expect(const GameFilterState(result: GameResultFilter.won).selectionLabel(l10n), 'Won');
    });

    test('shows a label for every result value', () {
      expect(const GameFilterState(result: GameResultFilter.lost).selectionLabel(l10n), 'Lost');
      expect(const GameFilterState(result: GameResultFilter.draw).selectionLabel(l10n), 'Draw');
    });

    test('combines with other filters', () {
      expect(
        const GameFilterState(side: Side.white, result: GameResultFilter.won).selectionLabel(l10n),
        'White, Won',
      );
      expect(
        GameFilterState(
          perfs: {Perf.blitz}.lock,
          result: GameResultFilter.won,
        ).selectionLabel(l10n),
        '${Perf.blitz.shortLabel(l10n)}, Won',
      );
    });

    test('falls back to the all games label when nothing is set', () {
      expect(const GameFilterState().selectionLabel(l10n), l10n.mobileAllGames);
    });
  });

  group('GameFilter.setFilter', () {
    test('applies the result filter and can clear it again', () async {
      final container = await makeContainer();
      final provider = gameFilterProvider(null);
      container.listen(provider, (_, _) {});
      final notifier = container.read(provider.notifier);

      notifier.setFilter(const GameFilterState(result: GameResultFilter.won, side: Side.white));
      expect(container.read(provider).result, GameResultFilter.won);
      expect(container.read(provider).side, Side.white);

      notifier.setFilter(const GameFilterState());
      expect(container.read(provider).result, isNull);
      expect(container.read(provider).side, isNull);
    });

    test('keeps the opponent filter that is managed outside of the sheet', () async {
      const opponent = User(id: UserId('opponent'), username: 'Opponent', perfs: IMap.empty());
      final container = await makeContainer();
      final provider = gameFilterProvider(const GameFilterState(opponent: opponent));
      container.listen(provider, (_, _) {});
      final notifier = container.read(provider.notifier);

      notifier.setFilter(const GameFilterState(result: GameResultFilter.won));

      expect(container.read(provider).result, GameResultFilter.won);
      expect(container.read(provider).opponent, opponent);
    });
  });
}

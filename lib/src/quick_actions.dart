import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_screen.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quick_actions.g.dart';

@Riverpod(keepAlive: true)
QuickActionService quickActionService(Ref ref) {
  final service = QuickActionService(ref);
  //ref.onDispose(service.dispose);
  ref.listen<RecentGameSeekPrefs>(recentGameSeekProvider, (previous, next) {
    service.setQuickActions(next.seeks);
  });
  return service;
}

class QuickActionService {
  QuickActionService(this.ref);

  final Ref ref;

  final QuickActions quickActions = const QuickActions();
  BuildContext? context;

  void start(BuildContext currentlyContext) {
    context = currentlyContext;
    final recentSeeks = ref.read(recentGameSeekProvider).seeks;
    quickActions.initialize((String shortcutType) {
      if (shortcutType.startsWith('recent_seek_')) {
        final index = int.tryParse(shortcutType.split('_').last);
        if (index != null) {
          Navigator.of(
            context!,
            rootNavigator: true,
          ).push(GameScreen.buildRoute(context!, seek: recentSeeks[index]));
        }
      } else if (shortcutType == 'play_puzzles') {
        Navigator.of(
          context!,
          rootNavigator: true,
        ).push(PuzzleScreen.buildRoute(context!, angle: const PuzzleTheme(PuzzleThemeKey.mix)));
      }
    });
    setQuickActions(recentSeeks);
  }

  void setQuickActions(IList<GameSeek> recentSeeks) {
    if (context == null) return;
    quickActions.setShortcutItems(<ShortcutItem>[
      ShortcutItem(
        type: 'play_puzzles',
        localizedTitle: AppLocalizations.of(context!).puzzleThemeMix,
        icon: 'extension',
      ),

      ...recentSeeks.asMap().entries.map((entry) {
        final index = entry.key;
        final seek = entry.value;

        final time = seek.clock != null ? seek.clock!.$1.inMinutes.toString() : '-';
        final increment = seek.clock != null ? seek.clock!.$2.inSeconds.toString() : '0';
        final rated = seek.rated
            ? AppLocalizations.of(context!).ratedTournament
            : AppLocalizations.of(context!).casualTournament;

        final variant = (seek.variant == Variant.standard)
            ? Variant.standard.label
            : (seek.variant != null && seek.timeIncrement != null)
            ? Perf.fromVariantAndSpeed(
                seek.variant!,
                Speed.fromTimeIncrement(seek.timeIncrement!),
              ).shortTitle
            : ' ';

        return ShortcutItem(
          type: 'recent_seek_$index',
          localizedTitle: '$time+$increment $rated $variant',
          localizedSubtitle: AppLocalizations.of(context!).recentGames,
          icon: 'add_icon',
        );
      }),
    ]);
  }
}

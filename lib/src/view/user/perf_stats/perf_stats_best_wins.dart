import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/user/perf_stats/perf_stats_common.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:material_ui/material_ui.dart';

class const PerfStatsBestWins({required final IList<UserPerfGame> games, required final User user})
    extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListSection(
      header: Text(context.l10n.perfStatBestRated, style: Styles.sectionTitle),
      margin: const EdgeInsets.only(top: 10.0),
      hasLeading: false,
      children: [
        for (final game in games)
          _BestWinTile(
            onTap: () async {
              final gameIds = ISet(games.map((g) => g.gameId));
              final list = await ref.read(gameRepositoryProvider).getGamesByIds(gameIds);
              final gameData = list.firstWhereOrNull((g) => g.id == game.gameId);
              if (context.mounted && gameData != null && gameData.variant.isReadSupported) {
                Navigator.of(context).pushHidingTabBar(
                  AnalysisScreen.buildRoute(
                    AnalysisOptions.archivedGame(
                      orientation: user.id == gameData.white.user?.id ? Side.white : Side.black,
                      gameId: gameData.id,
                      initialMoveCursor: 0,
                    ),
                  ),
                );
              } else if (context.mounted && gameData != null) {
                showSnackBar(context, 'This variant is not supported yet');
              }
            },
            playerTitle: UserFullNameWidget(user: game.opponent, rating: game.opponentRating),
            subtitle: Text(perfStatsDateFormat.format(game.finishedAt)),
          ),
      ],
    );
  }
}

class const _BestWinTile({
  required final Widget playerTitle,
  final Widget? subtitle,
  final GestureTapCallback? onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: playerTitle,
      subtitle: subtitle != null
          ? DefaultTextStyle.merge(
              child: subtitle!,
              style: TextStyle(color: textShade(context, Styles.subtitleOpacity)),
            )
          : null,
    );
  }
}

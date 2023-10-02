import 'package:flutter/cupertino.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/view/game/archived_game_screen.dart';

class RecentGames extends ConsumerWidget {
  const RecentGames({required this.user, super.key});

  final LightUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentGames = ref.watch(userRecentGamesProvider(userId: user.id));

    Widget getResultIcon(ArchivedGameData game, Side mySide) {
      if (game.status == GameStatus.aborted ||
          game.status == GameStatus.noStart) {
        return const Icon(
          CupertinoIcons.xmark_square_fill,
          color: LichessColors.grey,
        );
      } else {
        return game.winner == null
            ? const Icon(
                CupertinoIcons.equal_square_fill,
                color: LichessColors.brag,
              )
            : game.winner == mySide
                ? const Icon(
                    CupertinoIcons.plus_square_fill,
                    color: LichessColors.good,
                  )
                : const Icon(
                    CupertinoIcons.minus_square_fill,
                    color: LichessColors.red,
                  );
      }
    }

    return recentGames.when(
      data: (data) {
        if (data.isEmpty) {
          return kEmptyWidget;
        }
        return ListSection(
          header: Text(context.l10n.recentGames, style: Styles.sectionTitle),
          hasLeading: true,
          children: data.map((game) {
            final mySide = game.white.id == user.id ? Side.white : Side.black;
            final me = game.white.id == user.id ? game.white : game.black;
            final opponent = game.white.id == user.id ? game.black : game.white;

            return GameListTile(
              onTap: game.variant.isSupported
                  ? () {
                      pushPlatformRoute(
                        context,
                        rootNavigator: true,
                        builder: (context) => ArchivedGameScreen(
                          gameData: game,
                          orientation: user.id == game.white.id
                              ? Side.white
                              : Side.black,
                        ),
                      );
                    }
                  : null,
              icon: game.perf.icon,
              playerTitle: PlayerTitle(
                userName: opponent.displayName(context),
                title: opponent.title,
                rating: opponent.rating,
              ),
              subtitle: Text(
                timeago.format(game.lastMoveAt),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (me.analysis != null) ...[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.chart_bar_alt_fill,
                          color: textShade(context, 0.5),
                        ),
                        Text(
                          me.analysis!.accuracy.toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: textShade(context, Styles.subtitleOpacity),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 5),
                  ],
                  getResultIcon(game, mySide),
                ],
              ),
            );
          }).toList(),
        );
      },
      error: (error, stackTrace) {
        debugPrint(
          'SEVERE: [RecentGames] could not recent games; $error\n$stackTrace',
        );
        return Padding(
          padding: Styles.bodySectionPadding,
          child: const Text('Could not load recent games.'),
        );
      },
      loading: () => Shimmer(
        child: ShimmerLoading(
          isLoading: true,
          child: ListSection.loading(
            itemsNumber: 10,
            header: true,
          ),
        ),
      ),
    );
  }
}

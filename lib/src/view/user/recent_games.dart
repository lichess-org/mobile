import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/game_storage.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/archived_game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_list_tile.dart';
import 'package:lichess_mobile/src/view/game/standalone_game_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timeago/timeago.dart' as timeago;

part 'recent_games.g.dart';

@riverpod
Future<IList<LightArchivedGame>> _userRecentGames(
  _UserRecentGamesRef ref, {
  required UserId userId,
}) {
  return ref.withClientCacheFor(
    (client) => GameRepository(client).getRecentGames(userId),
    // cache is important because the associated widget is in a [ListView] and
    // the provider may be instanciated multiple times in a short period of time
    // (e.g. when scrolling)
    // TODO: consider debouncing the request instead of caching it, or make the
    // request in the parent widget and pass the result to the child
    const Duration(minutes: 1),
  );
}

class RecentGames extends ConsumerWidget {
  const RecentGames({this.user, super.key});

  final LightUser? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    final userId = user?.id ?? session?.user.id;

    final recentGames = user != null
        ? ref.watch(_userRecentGamesProvider(userId: user!.id))
        : session != null
            ? ref.watch(accountRecentGamesProvider)
            : ref.watch(recentStoredGamesProvider).whenData((data) {
                return data.map((e) => e.game.data).toIList();
              });

    Widget getResultIcon(LightArchivedGame game, Side mySide) {
      if (game.status == GameStatus.aborted ||
          game.status == GameStatus.noStart) {
        return const Icon(
          CupertinoIcons.xmark_square_fill,
          color: LichessColors.grey,
        );
      } else {
        return game.winner == null
            ? Icon(
                CupertinoIcons.equal_square_fill,
                color: context.lichessColors.brag,
              )
            : game.winner == mySide
                ? Icon(
                    CupertinoIcons.plus_square_fill,
                    color: context.lichessColors.good,
                  )
                : Icon(
                    CupertinoIcons.minus_square_fill,
                    color: context.lichessColors.error,
                  );
      }
    }

    return recentGames.when(
      data: (data) {
        if (data.isEmpty) {
          return kEmptyWidget;
        }
        return ListSection(
          header: Text(context.l10n.recentGames),
          hasLeading: true,
          showDividerBetweenTiles: true,
          children: data.map((game) {
            final mySide =
                game.white.user?.id == userId ? Side.white : Side.black;
            final me = game.white.user?.id == userId ? game.white : game.black;
            final opponent =
                game.white.user?.id == userId ? game.black : game.white;

            return GameListTile(
              game: game,
              mySide: userId == game.white.user?.id ? Side.white : Side.black,
              onTap: game.variant.isSupported
                  ? () {
                      pushPlatformRoute(
                        context,
                        rootNavigator: true,
                        builder: (context) => game.fullId != null
                            ? StandaloneGameScreen(
                                params: InitialStandaloneGameParams(
                                  id: game.fullId!,
                                ),
                              )
                            : ArchivedGameScreen(
                                gameData: game,
                                orientation: userId == game.white.user?.id
                                    ? Side.white
                                    : Side.black,
                              ),
                      );
                    }
                  : null,
              icon: game.perf.icon,
              playerTitle: UserFullNameWidget.player(
                user: opponent.user,
                aiLevel: opponent.aiLevel,
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

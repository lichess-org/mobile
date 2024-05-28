import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/model/game/game_storage.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_list_tile.dart';
import 'package:lichess_mobile/src/view/user/full_games_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    final connectivity = ref.watch(connectivityProvider);
    final session = ref.watch(authSessionProvider);
    final userId = user?.id ?? session?.user.id;

    final recentGames = user != null
        ? ref
            .watch(_userRecentGamesProvider(userId: user!.id))
            .whenData((data) {
            return data
                .map(
                  (e) =>
                      // user is not null for at least one of the players
                      (e, e.white.user?.id == userId ? Side.white : Side.black),
                )
                .toIList();
          })
        : session != null &&
                (connectivity.valueOrNull?.isOnline ?? false) == true
            ? ref.watch(accountRecentGamesProvider).whenData((data) {
                return data
                    .map(
                      (e) => (
                        e,
                        // user is not null for at least one of the players
                        e.white.user?.id == userId ? Side.white : Side.black
                      ),
                    )
                    .toIList();
              })
            : ref.watch(recentStoredGamesProvider).whenData((data) {
                return data
                    // we can assume that `youAre` is not null either for logged
                    // in users or for anonymous users
                    .map((e) => (e.game.data, e.game.youAre ?? Side.white))
                    .toIList();
              });

    return recentGames.when(
      data: (data) {
        if (data.isEmpty) {
          return const SizedBox.shrink();
        }
        final u = user ?? ref.watch(authSessionProvider)?.user;
        return ListSection(
          header: Text(context.l10n.recentGames),
          hasLeading: true,
          headerTrailing: u != null
              ? NoPaddingTextButton(
                  onPressed: () {
                    pushPlatformRoute(
                      context,
                      builder: (context) => FullGameScreen(user: u),
                    );
                  },
                  child: Text(
                    context.l10n.more,
                  ),
                )
              : null,
          children: data.map((item) {
            return ExtendedGameListTile(item: item, userId: userId);
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

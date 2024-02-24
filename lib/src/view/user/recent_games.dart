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
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
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
    (client) => GameRepository(client).getRecentGames(userId, 10),
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
    final recentGames = user != null
        ? ref.watch(_userRecentGamesProvider(userId: user!.id))
        : ref.watch(accountRecentGamesProvider(10));

    final userId = user?.id ?? ref.watch(authSessionProvider)?.user.id;

    return recentGames.when(
      data: (data) {
        if (data.isEmpty) {
          return kEmptyWidget;
        }
        return ListSection(
          header: Text(context.l10n.recentGames),
          hasLeading: true,
          headerTrailing: NoPaddingTextButton(
            onPressed: () {
              pushPlatformRoute(
                context,
                builder: (context) => FullGameScreen(user: user),
              );
            },
            child: Text(
              context.l10n.more,
            ),
          ),
          children: data.map((game) {
            return ExtendedGameListTile(game: game, userId: userId);
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

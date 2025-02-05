import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_list_tile.dart';
import 'package:lichess_mobile/src/view/user/game_history_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

/// A widget that show a list of recent games.
///
/// The [user] should be provided only if the games are for a specific user. If the
/// games are for the current logged in user, the [user] should be null.
class RecentGamesWidget extends ConsumerWidget {
  const RecentGamesWidget({
    required this.recentGames,
    required this.user,
    required this.nbOfGames,
    this.maxGamesToShow = 10,
    super.key,
  });

  final LightUser? user;
  final AsyncValue<IList<LightArchivedGameWithPov>> recentGames;
  final int nbOfGames;
  final int maxGamesToShow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityChangesProvider);

    return recentGames.when(
      data: (data) {
        if (data.isEmpty) {
          return const SizedBox.shrink();
        }
        final list = data.take(maxGamesToShow);
        return ListSection(
          header: Text(context.l10n.recentGames),
          hasLeading: true,
          headerTrailing:
              nbOfGames > list.length
                  ? NoPaddingTextButton(
                    onPressed: () {
                      pushPlatformRoute(
                        context,
                        builder:
                            (context) => GameHistoryScreen(
                              user: user,
                              isOnline: connectivity.valueOrNull?.isOnline == true,
                            ),
                      );
                    },
                    child: Text(context.l10n.more),
                  )
                  : null,
          children: [for (final item in list) GameListTile(item: item)],
        );
      },
      error: (error, stackTrace) {
        debugPrint('SEVERE: [RecentGames] could not recent games; $error\n$stackTrace');
        return const Padding(
          padding: Styles.bodySectionPadding,
          child: Text('Could not load recent games.'),
        );
      },
      loading:
          () => Shimmer(
            child: ShimmerLoading(
              isLoading: true,
              child: ListSection.loading(itemsNumber: 10, header: true, hasLeading: true),
            ),
          ),
    );
  }
}

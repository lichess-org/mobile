import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/game/game_history.dart';
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

/// A widget that show a list of recent games for a given player or the current user.
///
/// If [user] is not provided, the current logged in user's recent games are displayed.
/// If the current user is not logged in, or there is no connectivity, the stored recent games are displayed instead.
class RecentGamesWidget extends ConsumerWidget {
  const RecentGamesWidget({this.user, this.maxGamesToShow = 10, super.key});

  final LightUser? user;
  final int maxGamesToShow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityChangesProvider);
    final session = ref.watch(authSessionProvider);
    final userId = user?.id ?? session?.user.id;

    final recentGames =
        user != null
            ? ref.watch(userRecentGamesProvider(userId: user!.id))
            : ref.watch(myRecentGamesProvider);

    final nbOfGames =
        ref
            .watch(
              userNumberOfGamesProvider(user, isOnline: connectivity.valueOrNull?.isOnline == true),
            )
            .valueOrNull ??
        0;

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
          children:
              list.map((item) {
                return ExtendedGameListTile(item: item, userId: userId);
              }).toList(),
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

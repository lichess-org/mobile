import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
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

class RecentGames extends ConsumerWidget {
  const RecentGames({this.user, super.key});

  final LightUser? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);
    final session = ref.watch(authSessionProvider);
    final userId = user?.id ?? session?.user.id;

    final recentGames = user != null
        ? ref.watch(userRecentGamesProvider(userId: user!.id))
        : session != null && (isOnline.valueOrNull ?? false) == true
            ? ref.watch(accountRecentGamesProvider)
            : ref.watch(recentStoredGamesProvider).whenData((data) {
                return data.map((e) => e.game.data).toIList();
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

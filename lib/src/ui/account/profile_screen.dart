import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/model/auth/auth_actions_notifier.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/ui/settings/settings_screen.dart';
import 'package:lichess_mobile/src/ui/user/user_screen.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

final recentGamesProvider = FutureProvider.autoDispose
    .family<IList<ArchivedGameData>, UserId>((ref, userId) {
  final repo = ref.watch(gameRepositoryProvider);
  return Result.release(repo.getUserGames(userId));
});

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _androidRefreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    final authState = ref.watch(authStateChangesProvider);
    final authActionsAsync = ref.watch(authActionsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.profile),
        actions: [
          IconButton(
            tooltip: context.l10n.settings,
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            ),
          ),
        ],
      ),
      body: authState.maybeWhen(
        data: (account) {
          return account != null
              ? RefreshIndicator(
                  key: _androidRefreshKey,
                  onRefresh: () => _refreshData(account),
                  child: UserScreenBody(user: account, showPlayerTitle: true),
                )
              : Center(
                  child: FatButton(
                    semanticsLabel: context.l10n.signIn,
                    onPressed: authActionsAsync.isLoading
                        ? null
                        : () => ref.read(authActionsProvider.notifier).signIn(),
                    child: Text(context.l10n.signIn),
                  ),
                );
        },
        orElse: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    final authState = ref.watch(authStateChangesProvider);
    final authActionsAsync = ref.watch(authActionsProvider);
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(context.l10n.profile),
            trailing: CupertinoIconButton(
              semanticsLabel: context.l10n.settings,
              onPressed: () => Navigator.of(context).push<void>(
                CupertinoPageRoute(
                  title: context.l10n.settings,
                  builder: (context) => const SettingsScreen(),
                ),
              ),
              icon: const Icon(Icons.settings),
            ),
          ),
          ...authState.maybeWhen(
            data: (account) {
              return [
                if (account != null)
                  CupertinoSliverRefreshControl(
                    onRefresh: () => _refreshData(account),
                  ),
                if (account != null)
                  SliverSafeArea(
                    top: false,
                    sliver: UserScreenBody(
                      user: account,
                      showPlayerTitle: true,
                      inCustomScrollView: true,
                    ),
                  )
                else
                  SliverFillRemaining(
                    child: Center(
                      child: FatButton(
                        semanticsLabel: context.l10n.signIn,
                        onPressed: authActionsAsync.isLoading
                            ? null
                            : () =>
                                ref.read(authActionsProvider.notifier).signIn(),
                        child: Text(context.l10n.signIn),
                      ),
                    ),
                  ),
              ];
            },
            orElse: () => const [
              SliverFillRemaining(
                child: Center(child: CircularProgressIndicator.adaptive()),
              )
            ],
          ),
        ],
      ),
    );
  }

  // TODO also refresh user account data for perfs
  Future<void> _refreshData(User account) {
    return ref.refresh(recentGamesProvider(account.id).future);
  }
}

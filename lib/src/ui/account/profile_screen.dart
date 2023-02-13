import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/common/errors.dart';
import 'package:lichess_mobile/src/model/account/account_providers.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/ui/settings/settings_screen.dart';
import 'package:lichess_mobile/src/ui/user/user_screen.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

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
    final accountProfile = ref.watch(accountProvider);
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
      body: accountProfile.when(
        data: (account) {
          return RefreshIndicator(
            key: _androidRefreshKey,
            onRefresh: () => _refreshData(account),
            child: UserScreenBody(user: account, showPlayerTitle: true),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) {
          if (error is UnauthorizedException) {
            return _SignInBody();
          } else {
            return const Center(child: Text('Could not load profile'));
          }
        },
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    final accountProfile = ref.watch(accountProvider);
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
          ...accountProfile.when(
            data: (account) {
              return [
                CupertinoSliverRefreshControl(
                  onRefresh: () => _refreshData(account),
                ),
                SliverSafeArea(
                  top: false,
                  sliver: UserScreenBody(
                    user: account,
                    showPlayerTitle: true,
                    inCustomScrollView: true,
                  ),
                ),
              ];
            },
            loading: () => const [
              SliverFillRemaining(
                child: Center(child: CircularProgressIndicator.adaptive()),
              )
            ],
            error: (error, _) {
              if (error is UnauthorizedException) {
                return [
                  SliverFillRemaining(
                    child: _SignInBody(),
                  )
                ];
              } else {
                return const [
                  SliverFillRemaining(
                    child: Center(
                      child: Text('Could not load profile'),
                    ),
                  )
                ];
              }
            },
          ),
        ],
      ),
    );
  }

  // TODO also refresh user account data for perfs
  Future<void> _refreshData(User account) {
    return ref.refresh(userRecentGamesProvider(userId: account.id).future);
  }
}

class _SignInBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authControllerProvider);

    return Center(
      child: FatButton(
        semanticsLabel: context.l10n.signIn,
        onPressed: authController.isLoading
            ? null
            : () => ref.read(authControllerProvider.notifier).signIn(),
        child: Text(context.l10n.signIn),
      ),
    );
  }
}

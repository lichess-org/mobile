import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/user_session.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/ui/settings/settings_screen.dart';
import 'package:lichess_mobile/src/ui/user/user_screen.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/player.dart';

part 'profile_screen.g.dart';

@riverpod
Future<User?> _sessionProfile(_SessionProfileRef ref) async {
  final session = ref.watch(userSessionStateProvider);
  final accountRepo = ref.watch(accountRepositoryProvider);
  if (session != null) {
    return Result.release(accountRepo.getProfile());
  }
  return null;
}

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
    final sessionProfile = ref.watch(_sessionProfileProvider);
    return sessionProfile.when(
      data: (account) {
        return account != null
            ? Scaffold(
                appBar: AppBar(
                  title: PlayerTitle(
                    userName: account.username,
                    title: account.title,
                  ),
                  actions: const [
                    _SettingsButton(),
                  ],
                ),
                body: RefreshIndicator(
                  key: _androidRefreshKey,
                  onRefresh: () => _refreshData(account),
                  child: UserScreenBody(user: account),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  title: Text(context.l10n.profile),
                  actions: const [
                    _SettingsButton(),
                  ],
                ),
                body: _SignInBody(),
              );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) {
        return const Center(child: Text('Could not load profile.'));
      },
    );
  }

  Widget _buildIos(BuildContext context) {
    final sessionProfile = ref.watch(_sessionProfileProvider);
    return sessionProfile.when(
      data: (account) {
        return account != null
            ? CupertinoPageScaffold(
                child: CustomScrollView(
                  slivers: [
                    CupertinoSliverNavigationBar(
                      largeTitle: PlayerTitle(
                        userName: account.username,
                        title: account.title,
                      ),
                      trailing: const _SettingsButton(),
                    ),
                    CupertinoSliverRefreshControl(
                      onRefresh: () => _refreshData(account),
                    ),
                    SliverSafeArea(
                      top: false,
                      sliver: UserScreenBody(
                        user: account,
                        inCustomScrollView: true,
                      ),
                    ),
                  ],
                ),
              )
            : CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  middle: Text(context.l10n.profile),
                  trailing: const _SettingsButton(),
                ),
                child: _SignInBody(),
              );
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (error, _) {
        return const Center(child: Text('Could not load profile.'));
      },
    );
  }

  Future<void> _refreshData(User account) {
    return ref
        .refresh(userRecentGamesProvider(userId: account.id).future)
        .then((_) => ref.refresh(_sessionProfileProvider));
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton();

  @override
  Widget build(BuildContext context) {
    return defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoIconButton(
            semanticsLabel: context.l10n.settings,
            onPressed: () => Navigator.of(context).push<void>(
              CupertinoPageRoute(
                title: context.l10n.settings,
                builder: (context) => const SettingsScreen(),
              ),
            ),
            icon: const Icon(Icons.settings),
          )
        : IconButton(
            tooltip: context.l10n.settings,
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            ),
          );
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

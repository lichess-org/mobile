import 'package:async/async.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/view/settings/settings_screen.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/player.dart';

part 'profile_tab_screen.g.dart';

@riverpod
Future<User?> _sessionProfile(_SessionProfileRef ref) async {
  final session = ref.watch(authSessionProvider);
  final accountRepo = ref.watch(accountRepositoryProvider);
  if (session != null) {
    return Result.release(accountRepo.getProfile());
  }
  return null;
}

class ProfileTabScreen extends ConsumerStatefulWidget {
  const ProfileTabScreen({super.key});

  @override
  ConsumerState<ProfileTabScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileTabScreen> {
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
                    isPatron: account.isPatron,
                  ),
                  actions: const [
                    _SettingsButton(),
                  ],
                ),
                body: RefreshIndicator(
                  key: _androidRefreshKey,
                  onRefresh: () => _refreshData(account),
                  child: ListView(
                    controller: profileScrollController,
                    children: buildUserScreenList(account),
                  ),
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
        return Scaffold(
          appBar: AppBar(
            actions: const [
              _SettingsButton(),
            ],
          ),
          body: FullScreenRetryRequest(
            onRetry: () => ref.invalidate(_sessionProfileProvider),
          ),
        );
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
                  controller: profileScrollController,
                  slivers: [
                    CupertinoSliverNavigationBar(
                      largeTitle: PlayerTitle(
                        userName: account.username,
                        title: account.title,
                        isPatron: account.isPatron,
                      ),
                      trailing: const _SettingsButton(),
                    ),
                    CupertinoSliverRefreshControl(
                      onRefresh: () => _refreshData(account),
                    ),
                    SliverSafeArea(
                      top: false,
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          buildUserScreenList(account),
                        ),
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
        return CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(
            middle: SizedBox.shrink(),
            trailing: _SettingsButton(),
          ),
          child: FullScreenRetryRequest(
            onRetry: () => ref.invalidate(_sessionProfileProvider),
          ),
        );
      },
    );
  }

  Future<void> _refreshData(User account) {
    return Future.wait([
      ref.refresh(userRecentGamesProvider(userId: account.id).future),
      ref.refresh(userActivityProvider(id: account.id).future),
      ref.refresh(_sessionProfileProvider.future),
    ]);
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton();

  @override
  Widget build(BuildContext context) {
    return SettingsButton(
      onPressed: () => pushPlatformRoute(
        context,
        title: context.l10n.settingsSettings,
        builder: (_) => const SettingsScreen(),
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

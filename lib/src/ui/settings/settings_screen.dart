import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/bottom_navigation.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/model/auth/auth_actions_notifier.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/model/settings/theme_mode_provider.dart';

import './theme_mode_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settings),
      ),
      body: _Body(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final authState = ref.watch(authStateChangesProvider);
    final authActionsAsync = ref.watch(authActionsProvider);
    return LoadingOverlay(
      isLoading: authActionsAsync.isLoading,
      progressIndicator: const CircularProgressIndicator.adaptive(),
      child: SafeArea(
        child: ListView(
          children: [
            ListSection(
              // showDivider: true,
              children: [
                SettingsListTile(
                  settingsLabel: context.l10n.background,
                  settingsValue: ThemeModeScreen.themeTitle(context, themeMode),
                  onTap: () => pushPlatformRoute(
                    context: context,
                    title: context.l10n.background,
                    builder: (context) => const ThemeModeScreen(),
                  ),
                ),
              ],
            ),
            authState.maybeWhen(
              data: (data) {
                return data != null
                    ? ListSection(
                        children: [
                          PlatformListTile(
                            leading: const Icon(Icons.exit_to_app),
                            title: Text(context.l10n.logOut),
                            onTap: authActionsAsync.isLoading
                                ? null
                                : () async {
                                    await ref
                                        .read(authActionsProvider.notifier)
                                        .signOut();
                                    ref
                                        .read(currentBottomTabProvider.notifier)
                                        .state = BottomTab.play;
                                  },
                          ),
                        ],
                      )
                    : const SizedBox.shrink();
              },
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

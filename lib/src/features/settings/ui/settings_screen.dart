import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings_group_tile.dart';
import 'package:lichess_mobile/src/widgets/bottom_navigation.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/features/auth/ui/auth_widget_notifier.dart';
import 'package:lichess_mobile/src/features/auth/data/auth_repository.dart';

import './theme_mode_screen.dart';
import './theme_mode_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConsumerPlatformWidget(
      ref: ref,
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settings),
      ),
      body: _buildBody(context, ref),
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _buildBody(context, ref),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final authState = ref.watch(authStateChangesProvider);
    final authActionsAsync = ref.watch(authWidgetProvider);
    return LoadingOverlay(
      isLoading: authActionsAsync.isLoading,
      progressIndicator: const CircularProgressIndicator.adaptive(),
      child: SafeArea(
        child: ListView(
          padding: kBodyPadding,
          children: [
            const SizedBox(height: 10),
            PlatformCard(
              child: SettingsGroupTile(
                icon: const Icon(Icons.brightness_medium),
                settingsLabel: context.l10n.background,
                settingsValue: ThemeModeScreen.themeTitle(context, themeMode),
                onTap: () => pushPlatformRoute(
                  context: context,
                  title: context.l10n.background,
                  builder: (context) => const ThemeModeScreen(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            authState.maybeWhen(
                data: ((data) {
                  return data != null
                      ? PlatformCard(
                          child: ListTile(
                            leading: const Icon(Icons.exit_to_app),
                            title: Text(context.l10n.logOut),
                            onTap: authActionsAsync.isLoading
                                ? null
                                : () async {
                                    await ref
                                        .read(authWidgetProvider.notifier)
                                        .signOut();
                                    ref
                                        .read(currentBottomTabProvider.notifier)
                                        .state = BottomTab.play;
                                  },
                          ),
                        )
                      : const SizedBox.shrink();
                }),
                orElse: () => const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}

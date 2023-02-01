import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/bottom_navigation.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/style.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/features/auth/ui/auth_actions_notifier.dart';
import 'package:lichess_mobile/src/features/auth/data/auth_repository.dart';

import './theme_mode_screen.dart';
import './theme_mode_notifier.dart';

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
              data: (data) {
                return data != null
                    ? PlatformCard(
                        child: PlatformListTile(
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

/// A tappable [ListTile] that represents a settings value.
class SettingsGroupTile extends StatelessWidget {
  const SettingsGroupTile({
    required this.icon,
    required this.settingsLabel,
    required this.settingsValue,
    required this.onTap,
    super.key,
  });

  final Icon icon;
  final String settingsLabel;
  final String settingsValue;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final tile = defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoListTile(
            leading: icon,
            title: Text(settingsLabel),
            additionalInfo: Text(settingsValue),
            onTap: onTap,
            trailing: const CupertinoListTileChevron(),
          )
        : ListTile(
            leading: icon,
            title: Text(settingsLabel),
            subtitle: Text(
              settingsValue,
              style: TextStyle(color: textShade(context, kSubtitleOpacity)),
            ),
            onTap: onTap,
            trailing: const Icon(Icons.keyboard_arrow_right),
          );
    return Semantics(
      container: true,
      button: true,
      label: '$settingsLabel: $settingsValue',
      excludeSemantics: true,
      child: tile,
    );
  }
}

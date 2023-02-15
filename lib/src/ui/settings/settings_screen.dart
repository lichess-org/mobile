import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/bottom_navigation.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/settings/providers.dart';

import './theme_mode_screen.dart';
import './piece_set_screen.dart';

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
    final themeMode = ref.watch(themeModePrefProvider);
    final authController = ref.watch(authControllerProvider);
    final pieceSet = ref.watch(pieceSetPrefProvider);
    return SafeArea(
      child: ListView(
        children: [
          ListSection(
            hasLeading: true,
            showDivider: true,
            children: [
              SettingsListTile(
                icon: const Icon(Icons.brightness_medium),
                settingsLabel: context.l10n.background,
                settingsValue: ThemeModeScreen.themeTitle(context, themeMode),
                onTap: () {
                  if (defaultTargetPlatform == TargetPlatform.android) {
                    showChoicesPicker(
                      context,
                      choices: ThemeMode.values,
                      selectedItem: themeMode,
                      labelBuilder: (t) =>
                          Text(ThemeModeScreen.themeTitle(context, t)),
                      onSelectedItemChanged: (ThemeMode? value) => ref
                          .read(themeModePrefProvider.notifier)
                          .set(value ?? ThemeMode.system),
                    );
                  } else {
                    pushPlatformRoute(
                      context: context,
                      title: context.l10n.background,
                      builder: (context) => const ThemeModeScreen(),
                    );
                  }
                },
              ),
              SettingsListTile(
                icon: const Icon(LichessIcons.chess_knight),
                settingsLabel: context.l10n.pieceSet,
                settingsValue: pieceSet.label,
                onTap: () {
                  pushPlatformRoute(
                    context: context,
                    title: context.l10n.pieceSet,
                    builder: (context) => const PieceSetScreen(),
                  );
                },
              ),
            ],
          ),
          authController.when(
            data: (session) {
              return session != null
                  ? ListSection(
                      children: [
                        PlatformListTile(
                          leading: const Icon(Icons.exit_to_app),
                          title: Text(context.l10n.logOut),
                          onTap: () async {
                            await ref
                                .read(authControllerProvider.notifier)
                                .signOut();
                            ref.read(currentBottomTabProvider.notifier).state =
                                BottomTab.play;
                          },
                        ),
                      ],
                    )
                  : const SizedBox.shrink();
            },
            loading: () => const CircularProgressIndicator.adaptive(),
            error: (err, st) {
              debugPrint(
                'SEVERE: [SettingsScreen] error: $err\n$st',
              );
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

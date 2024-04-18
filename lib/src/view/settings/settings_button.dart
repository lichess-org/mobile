import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/settings/settings_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

/// A cogs icon button in the app bar
class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarIconButton(
      onPressed: () {
        pushPlatformRoute(
          context,
          title: context.l10n.settingsSettings,
          builder: (_) => const SettingsScreen(),
        );
      },
      semanticsLabel: context.l10n.settingsSettings,
      icon: const Icon(Icons.settings),
    );
  }
}

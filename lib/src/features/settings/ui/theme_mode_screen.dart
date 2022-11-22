import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/utils/extensions/l10n_context.dart';

import './theme_mode_controller.dart';

class ThemeModeScreen extends ConsumerWidget {
  const ThemeModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeControllerProvider);

    void onChanged(value) => ref
        .read(themeModeControllerProvider.notifier)
        .changeTheme(value ?? ThemeMode.system);

    return Scaffold(
      appBar: AppBar(title: const Text('Theme')),
      body: Column(
        children: [
          ListTile(
            title: Text(context.l10n.dark),
            leading: Radio<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: themeMode,
              onChanged: onChanged,
            ),
          ),
          ListTile(
            title: Text(context.l10n.light),
            leading: Radio<ThemeMode>(
              value: ThemeMode.light,
              groupValue: themeMode,
              onChanged: onChanged,
            ),
          ),
          ListTile(
            title: const Text('System'),
            leading: Radio<ThemeMode>(
              value: ThemeMode.system,
              groupValue: themeMode,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

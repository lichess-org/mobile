import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

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
          RadioListTile<ThemeMode>(
            title: Text(context.l10n.dark),
            value: ThemeMode.dark,
            groupValue: themeMode,
            onChanged: onChanged,
          ),
          RadioListTile<ThemeMode>(
            title: Text(context.l10n.light),
            value: ThemeMode.light,
            groupValue: themeMode,
            onChanged: onChanged,
          ),
          RadioListTile<ThemeMode>(
            title: const Text('System'),
            value: ThemeMode.system,
            groupValue: themeMode,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            title: const Text('Dark'),
            leading: Radio<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: themeMode,
              onChanged: onChanged,
            ),
          ),
          ListTile(
            title: const Text('Light'),
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

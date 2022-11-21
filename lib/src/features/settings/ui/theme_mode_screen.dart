import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/settings_repository.dart';

class ThemeModeScreen extends ConsumerWidget {
  const ThemeModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsRepo = ref.watch(settingsRepositoryProvider);
    final value = settingsRepo.getThemeMode();

    void onChanged(ThemeMode? value) {
      ref
          .read(settingsRepositoryProvider)
          .setThemeMode(value ?? ThemeMode.system);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Theme')),
      body: Column(
        children: [
          ListTile(
            title: const Text('Dark'),
            leading: Radio<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: value,
              onChanged: onChanged,
            ),
          ),
          ListTile(
            title: const Text('Light'),
            leading: Radio<ThemeMode>(
              value: ThemeMode.light,
              groupValue: value,
              onChanged: onChanged,
            ),
          ),
          ListTile(
            title: const Text('System'),
            leading: Radio<ThemeMode>(
              value: ThemeMode.system,
              groupValue: value,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

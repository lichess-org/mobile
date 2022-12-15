import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

import './theme_mode_notifier.dart';

class ThemeModeScreen extends ConsumerWidget {
  const ThemeModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    void onChanged(ThemeMode? value) => ref
        .read(themeModeProvider.notifier)
        .changeTheme(value ?? ThemeMode.system);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.background)),
      body: Column(
        children: [
          RadioListTile<ThemeMode>(
            title: Text(context.l10n.deviceTheme),
            value: ThemeMode.system,
            groupValue: themeMode,
            onChanged: onChanged,
          ),
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
        ],
      ),
    );
  }
}

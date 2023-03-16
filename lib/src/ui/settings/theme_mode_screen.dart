import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

import 'package:lichess_mobile/src/model/settings/general_preferences.dart';

class ThemeModeScreen extends StatelessWidget {
  const ThemeModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.background)),
      body: _Body(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _Body(),
    );
  }

  static String themeTitle(BuildContext context, ThemeMode theme) {
    switch (theme) {
      case ThemeMode.system:
        return context.l10n.deviceTheme;
      case ThemeMode.dark:
        return context.l10n.dark;
      case ThemeMode.light:
        return context.l10n.light;
    }
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(
      generalPreferencesProvider.select((state) => state.themeMode),
    );

    void onChanged(ThemeMode? value) => ref
        .read(generalPreferencesProvider.notifier)
        .setThemeMode(value ?? ThemeMode.system);

    return SafeArea(
      child: ListView(
        children: [
          ChoicePicker(
            choices: ThemeMode.values,
            selectedItem: themeMode,
            titleBuilder: (t) => Text(ThemeModeScreen.themeTitle(context, t)),
            onSelectedItemChanged: onChanged,
          )
        ],
      ),
    );
  }
}

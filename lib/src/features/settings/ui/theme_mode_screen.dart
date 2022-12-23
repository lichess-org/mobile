import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/list_tile_choice.dart';

import './theme_mode_notifier.dart';

class ThemeModeScreen extends ConsumerWidget {
  const ThemeModeScreen({super.key});
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
      appBar: AppBar(title: Text(context.l10n.background)),
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

    void onChanged(ThemeMode? value) => ref
        .read(themeModeProvider.notifier)
        .changeTheme(value ?? ThemeMode.system);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          ListTileChoice(
              choices: ThemeMode.values,
              selectedItem: themeMode,
              titleBuilder: (t) => Text(themeTitle(context, t)),
              onSelectedItemChanged: onChanged)
        ],
      ),
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

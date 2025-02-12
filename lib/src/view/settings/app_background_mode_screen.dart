import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class AppBackgroundModeScreen extends StatelessWidget {
  const AppBackgroundModeScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(
      context,
      screen: const AppBackgroundModeScreen(),
      title: context.l10n.background,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(appBarTitle: Text(context.l10n.background), body: _Body());
  }

  static String themeTitle(BuildContext context, BackgroundThemeMode theme) {
    switch (theme) {
      case BackgroundThemeMode.system:
        return context.l10n.deviceTheme;
      case BackgroundThemeMode.dark:
        return context.l10n.dark;
      case BackgroundThemeMode.light:
        return context.l10n.light;
    }
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(generalPreferencesProvider.select((state) => state.themeMode));

    void onChanged(BackgroundThemeMode? value) => ref
        .read(generalPreferencesProvider.notifier)
        .setBackgroundThemeMode(value ?? BackgroundThemeMode.system);

    return SafeArea(
      child: ListView(
        children: [
          ChoicePicker(
            choices: BackgroundThemeMode.values,
            selectedItem: themeMode,
            titleBuilder: (t) => Text(AppBackgroundModeScreen.themeTitle(context, t)),
            onSelectedItemChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

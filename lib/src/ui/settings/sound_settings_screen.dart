import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/settings/sound.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class SoundSettingsScreen extends StatelessWidget {
  const SoundSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.sound)),
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
    //final soundTheme = ref.watch(
    //  generalPreferencesProvider.select(
    //    (state) => state.soundTheme,
    //  ),
    //);

    //void onChanged(SoundTheme? value) => ref
    //    .read(generalPreferencesProvider.notifier)
    //    .setSoundTheme(value ?? SoundTheme.normal);

    void onChanged(SoundTheme? value) => {};

    return SafeArea(
      child: ListView(
        children: [
          ChoicePicker(
            choices: SoundTheme.values,
            selectedItem: SoundTheme.nes, //soundTheme,
            titleBuilder: (t) => Text(t.label),
            onSelectedItemChanged: onChanged,
          )
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:lichess_mobile/src/model/settings/sound_theme.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';

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
}

String soundThemeL10n(BuildContext context, SoundTheme theme) =>
    theme == SoundTheme.standard ? context.l10n.standard : theme.label;

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundTheme = ref.watch(
      generalPreferencesProvider.select(
        (state) => state.soundTheme,
      ),
    );

    void onChanged(SoundTheme? value) {
      ref
          .read(generalPreferencesProvider.notifier)
          .setSoundTheme(value ?? SoundTheme.standard);
      ref.read(soundServiceProvider).changeTheme(
            value ?? SoundTheme.standard,
            playSound: true,
          );
    }

    return SafeArea(
      child: ListView(
        children: [
          ChoicePicker(
            choices: SoundTheme.values,
            selectedItem: soundTheme,
            titleBuilder: (t) => Text(soundThemeL10n(context, t)),
            onSelectedItemChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

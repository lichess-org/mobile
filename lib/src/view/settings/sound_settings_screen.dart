import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

const kMasterVolumeValues = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];

class SoundSettingsScreen extends StatelessWidget {
  const SoundSettingsScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const SoundSettingsScreen());
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(appBarTitle: Text(context.l10n.sound), body: _Body());
  }
}

/// Localize the sound theme.
String soundThemeL10n(BuildContext context, SoundTheme theme) =>
    theme == SoundTheme.standard ? context.l10n.standard : theme.label;

/// Returns a volume label in percentage.
String volumeLabel(double value) => '${(value * 100).round()}%';

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final generalPrefs = ref.watch(generalPreferencesProvider);

    void onChanged(SoundTheme? value) {
      ref.read(generalPreferencesProvider.notifier).setSoundTheme(value ?? SoundTheme.standard);
      ref.read(soundServiceProvider).changeTheme(value ?? SoundTheme.standard, playSound: true);
    }

    return ListView(
      children: [
        ListSection(
          children: [
            SliderSettingsTile(
              icon: const Icon(Icons.volume_up),
              value: generalPrefs.masterVolume,
              values: kMasterVolumeValues,
              onChangeEnd: (value) {
                ref.read(generalPreferencesProvider.notifier).setMasterVolume(value);
              },
              labelBuilder: volumeLabel,
            ),
          ],
        ),
        ChoicePicker(
          notchedTile: true,
          choices: SoundTheme.values,
          selectedItem: generalPrefs.soundTheme,
          titleBuilder: (t) => Text(soundThemeL10n(context, t)),
          onSelectedItemChanged: onChanged,
        ),
      ],
    );
  }
}

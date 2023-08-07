import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/settings/play_preferences.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';

class CustomPlayScreen extends StatelessWidget {
  const CustomPlayScreen();

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildIos(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: _Body(),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.custom),
      ),
      body: const _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(playPreferencesProvider);
    final session = ref.watch(authSessionProvider);
    final isValidTimeControl = preferences.customTimeSeconds > 0 ||
        preferences.customIncrementSeconds > 0;

    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          PlatformListTile(
            title: Text.rich(
              TextSpan(
                text: '${context.l10n.minutesPerSide}: ',
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                children: [
                  TextSpan(
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    text: _clockTimeLabel(preferences.customTimeSeconds),
                  ),
                ],
              ),
            ),
            subtitle: NonLinearSlider(
              value: preferences.customTimeSeconds,
              values: kAvailableTimesInSeconds,
              labelBuilder: _clockTimeLabel,
              onChangeEnd: (num value) {
                ref
                    .read(playPreferencesProvider.notifier)
                    .setCustomTimeSeconds(value.toInt());
              },
            ),
          ),
          PlatformListTile(
            title: Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                text: '${context.l10n.incrementInSeconds}: ',
                children: [
                  TextSpan(
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    text: preferences.customIncrementSeconds.toString(),
                  ),
                ],
              ),
            ),
            subtitle: NonLinearSlider(
              value: preferences.customIncrementSeconds,
              values: kAvailableIncrementsInSeconds,
              onChangeEnd: (num value) {
                ref
                    .read(playPreferencesProvider.notifier)
                    .setCustomIncrementSeconds(value.toInt());
              },
            ),
          ),
          PlatformListTile(
            title: Text(context.l10n.variant),
            trailing: AdaptiveTextButton(
              onPressed: () {
                showChoicePicker(
                  context,
                  choices: [Variant.standard, Variant.chess960],
                  selectedItem: preferences.customVariant,
                  labelBuilder: (Variant variant) => Text(variant.label),
                  onSelectedItemChanged: (Variant variant) {
                    ref
                        .read(playPreferencesProvider.notifier)
                        .setCustomVariant(variant);
                  },
                );
              },
              child: Text(preferences.customVariant.label),
            ),
          ),
          if (session != null)
            PlatformListTile(
              title: Text(context.l10n.rated),
              trailing: Switch.adaptive(
                value: preferences.customRated,
                onChanged: (bool value) {
                  ref
                      .read(playPreferencesProvider.notifier)
                      .setCustomRated(value);
                },
              ),
            ),
          if (preferences.customRated == false)
            PlatformListTile(
              title: Text(context.l10n.side),
              trailing: AdaptiveTextButton(
                onPressed: () {
                  showChoicePicker<PlayableSide>(
                    context,
                    choices: PlayableSide.values,
                    selectedItem: preferences.customSide,
                    labelBuilder: (PlayableSide side) =>
                        Text(_customSideLabel(context, side)),
                    onSelectedItemChanged: (PlayableSide side) {
                      ref
                          .read(playPreferencesProvider.notifier)
                          .setCustomSide(side);
                    },
                  );
                },
                child: Text(_customSideLabel(context, preferences.customSide)),
              ),
            ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: FatButton(
              semanticsLabel: context.l10n.createAGame,
              onPressed: isValidTimeControl
                  ? () {
                      ref
                          .read(playPreferencesProvider.notifier)
                          .setSeekMode(SeekMode.custom);
                      pushPlatformRoute(
                        context,
                        rootNavigator: true,
                        builder: (BuildContext context) {
                          return GameScreen(
                            seek: GameSeek.customFromPrefs(
                              preferences,
                              session,
                            ),
                          );
                        },
                      );
                    }
                  : null,
              child: Text(context.l10n.createAGame),
            ),
          ),
        ],
      ),
    );
  }
}

String _clockTimeLabel(num seconds) {
  switch (seconds) {
    case 0:
      return '0';
    case 45:
      return '¾';
    case 30:
      return '½';
    case 15:
      return '¼';
    default:
      return (seconds / 60).toString().replaceAll('.0', '');
  }
}

String _customSideLabel(BuildContext context, PlayableSide side) {
  switch (side) {
    case PlayableSide.white:
      return context.l10n.white;
    case PlayableSide.black:
      return context.l10n.black;
    case PlayableSide.random:
      return context.l10n.randomColor;
  }
}

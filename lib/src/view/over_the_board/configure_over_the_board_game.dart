import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/model/over_the_board/over_the_board_clock.dart';
import 'package:lichess_mobile/src/model/over_the_board/over_the_board_game_controller.dart';
import 'package:lichess_mobile/src/model/settings/over_the_board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

void showConfigureGameSheet(BuildContext context, {required bool isDismissible}) {
  final double screenHeight = MediaQuery.sizeOf(context).height;
  showAdaptiveBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    isDismissible: isDismissible,
    constraints: BoxConstraints(maxHeight: screenHeight - (screenHeight / 10)),
    builder: (BuildContext context) {
      return const _ConfigureOverTheBoardGameSheet();
    },
  );
}

class _ConfigureOverTheBoardGameSheet extends ConsumerStatefulWidget {
  const _ConfigureOverTheBoardGameSheet();

  @override
  ConsumerState<_ConfigureOverTheBoardGameSheet> createState() =>
      _ConfigureOverTheBoardGameSheetState();
}

class _ConfigureOverTheBoardGameSheetState extends ConsumerState<_ConfigureOverTheBoardGameSheet> {
  late Variant chosenVariant;

  late TimeIncrement timeIncrement;

  @override
  void initState() {
    final gameState = ref.read(overTheBoardGameControllerProvider);
    chosenVariant = gameState.game.meta.variant;
    final clockProvider = ref.read(overTheBoardClockProvider);
    timeIncrement = clockProvider.timeIncrement;
    super.initState();
  }

  void _setTotalTime(num seconds) {
    setState(() {
      timeIncrement = TimeIncrement(seconds.toInt(), timeIncrement.increment);
    });
  }

  void _setIncrement(num seconds) {
    setState(() {
      timeIncrement = TimeIncrement(timeIncrement.time, seconds.toInt());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetScrollableContainer(
      children: [
        ListSection(
          materialFilledCard: true,
          children: [
            SettingsListTile(
              settingsLabel: Text(context.l10n.variant),
              settingsValue: chosenVariant.label,
              onTap: () {
                showChoicePicker<Variant>(
                  context,
                  choices:
                      playSupportedVariants
                          .where((variant) => variant != Variant.fromPosition)
                          .toList(),
                  selectedItem: chosenVariant,
                  labelBuilder: (Variant variant) => Text(variant.label),
                  onSelectedItemChanged:
                      (Variant variant) => setState(() {
                        chosenVariant = variant;
                      }),
                );
              },
            ),
            PlatformListTile(
              title: Text.rich(
                TextSpan(
                  text: '${context.l10n.minutesPerSide}: ',
                  children: [
                    TextSpan(
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      text: clockLabelInMinutes(timeIncrement.time),
                    ),
                  ],
                ),
              ),
              subtitle: NonLinearSlider(
                value: timeIncrement.time,
                values: kAvailableTimesInSeconds,
                labelBuilder: clockLabelInMinutes,
                onChange: Theme.of(context).platform == TargetPlatform.iOS ? _setTotalTime : null,
                onChangeEnd: _setTotalTime,
              ),
            ),
            PlatformListTile(
              title: Text.rich(
                TextSpan(
                  text: '${context.l10n.incrementInSeconds}: ',
                  children: [
                    TextSpan(
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      text: timeIncrement.increment.toString(),
                    ),
                  ],
                ),
              ),
              subtitle: NonLinearSlider(
                value: timeIncrement.increment,
                values: kAvailableIncrementsInSeconds,
                onChange: Theme.of(context).platform == TargetPlatform.iOS ? _setIncrement : null,
                onChangeEnd: _setIncrement,
              ),
            ),
          ],
        ),
        Padding(
          padding: Styles.horizontalBodyPadding,
          child: SecondaryButton(
            onPressed: () {
              ref.read(overTheBoardClockProvider.notifier).setupClock(timeIncrement);
              ref
                  .read(overTheBoardGameControllerProvider.notifier)
                  .startNewGame(chosenVariant, timeIncrement);
              Navigator.pop(context);
            },
            semanticsLabel: context.l10n.play,
            child: Text(context.l10n.play, style: Styles.bold),
          ),
        ),
      ],
    );
  }
}

void showConfigureDisplaySettings(BuildContext context) {
  showAdaptiveBottomSheet<void>(
    context: context,
    isDismissible: true,
    showDragHandle: true,
    builder: (BuildContext context) {
      return const OverTheBoardDisplaySettings();
    },
  );
}

class OverTheBoardDisplaySettings extends ConsumerWidget {
  const OverTheBoardDisplaySettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(overTheBoardPreferencesProvider);

    return BottomSheetScrollableContainer(
      children: [
        SwitchSettingTile(
          title: const Text('Use symmetric pieces'),
          value: prefs.symmetricPieces,
          onChanged:
              (_) => ref.read(overTheBoardPreferencesProvider.notifier).toggleSymmetricPieces(),
        ),
        SwitchSettingTile(
          title: const Text('Flip pieces and opponent info after move'),
          value: prefs.flipPiecesAfterMove,
          onChanged:
              (_) => ref.read(overTheBoardPreferencesProvider.notifier).toggleFlipPiecesAfterMove(),
        ),
      ],
    );
  }
}

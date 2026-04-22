import 'package:dartchess/dartchess.dart';
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
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:lichess_mobile/src/widgets/variant_app_bar_title.dart';

void showConfigureGameSheet(
  BuildContext context, {
  required bool isDismissible,
  required Variant initialVariant,
  String? initialFen,
}) {
  final double screenHeight = MediaQuery.sizeOf(context).height;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    constraints: BoxConstraints(maxHeight: screenHeight - (screenHeight / 10)),
    builder: (BuildContext context) {
      return _ConfigureOverTheBoardGameSheet(
        initialVariant: initialVariant,
        initialFen: initialFen,
      );
    },
  );
}

class _ConfigureOverTheBoardGameSheet extends ConsumerStatefulWidget {
  const _ConfigureOverTheBoardGameSheet({required this.initialVariant, this.initialFen});

  final Variant initialVariant;

  final String? initialFen;

  @override
  ConsumerState<_ConfigureOverTheBoardGameSheet> createState() =>
      _ConfigureOverTheBoardGameSheetState();
}

class _ConfigureOverTheBoardGameSheetState extends ConsumerState<_ConfigureOverTheBoardGameSheet> {
  late Variant chosenVariant;
  late TimeControlType chosenTimeControlType;

  late TimeIncrement timeIncrement;

  String? _fromPositionFen;
  final _fenController = TextEditingController();

  @override
  void initState() {
    // Auto-switch variant to fromPosition when an initialFen is given for a
    // standard game (mirrors the controller's fromVariant logic), and fall back
    // to standard when fromPosition arrives without a FEN (e.g. "New game"
    // after a fromPosition game).
    if (widget.initialFen != null && widget.initialVariant == Variant.standard) {
      chosenVariant = Variant.fromPosition;
    } else if (widget.initialFen == null && widget.initialVariant == Variant.fromPosition) {
      chosenVariant = Variant.standard;
    } else {
      chosenVariant = widget.initialVariant;
    }
    _fromPositionFen = widget.initialFen;
    if (widget.initialFen != null) {
      _fenController.text = widget.initialFen!;
    }
    _fenController.addListener(() {
      setState(() => _fromPositionFen = _fenController.text.isEmpty ? null : _fenController.text);
    });
    final clockProvider = ref.read(overTheBoardClockProvider);
    timeIncrement = clockProvider.timeIncrement;
    chosenTimeControlType = ref.read(overTheBoardPreferencesProvider).timeControlType;
    super.initState();
  }

  @override
  void dispose() {
    _fenController.dispose();
    super.dispose();
  }

  void _setTimeControlType(TimeControlType type) {
    ref.read(overTheBoardPreferencesProvider.notifier).setTimeControlType(type);
    setState(() {
      chosenTimeControlType = type;
      if (type == TimeControlType.unlimited) {
        timeIncrement = const TimeIncrement.infinite();
      } else if (timeIncrement.isInfinite) {
        timeIncrement = TimeIncrement.blitzDefault();
      }
    });
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

  bool get _isPlayEnabled =>
      chosenVariant != Variant.fromPosition ||
      (_fromPositionFen != null && _fromPositionFen!.isNotEmpty);

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
                  choices: playSupportedVariants.toList(),
                  selectedItem: chosenVariant,
                  labelBuilder: (variant) => VariantLabel(variant),
                  onSelectedItemChanged: (Variant variant) => setState(() {
                    chosenVariant = variant;
                  }),
                );
              },
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              child: chosenVariant == Variant.fromPosition
                  ? SmallBoardPreview(
                      orientation: Side.white,
                      fen: _fromPositionFen ?? kEmptyFEN,
                      description: TextField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: context.l10n.pasteTheFenStringHere,
                          suffixIcon: const Icon(Icons.paste),
                        ),
                        controller: _fenController,
                        readOnly: true,
                        onTap: () => pasteFenFromClipboard(context, _fenController),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            SettingsListTile(
              settingsLabel: Text(context.l10n.timeControl),
              settingsValue: chosenTimeControlType.label(context.l10n),
              onTap: () {
                showChoicePicker<TimeControlType>(
                  context,
                  choices: TimeControlType.values,
                  selectedItem: chosenTimeControlType,
                  labelBuilder: (TimeControlType control) => Text(control.label(context.l10n)),
                  onSelectedItemChanged: (TimeControlType control) => _setTimeControlType(control),
                );
              },
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 400),
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                children: [
                  ListTile(
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
                      onChange: _setTotalTime,
                      onChangeEnd: _setTotalTime,
                    ),
                  ),
                  ListTile(
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
                      onChange: _setIncrement,
                      onChangeEnd: _setIncrement,
                    ),
                  ),
                ],
              ),
              crossFadeState: timeIncrement.isInfinite
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            ),
          ],
        ),
        Padding(
          padding: Styles.horizontalBodyPadding,
          child: FilledButton(
            onPressed: _isPlayEnabled
                ? () {
                    ref.read(overTheBoardClockProvider.notifier).setupClock(timeIncrement);
                    ref
                        .read(overTheBoardGameControllerProvider.notifier)
                        .startNewGame(chosenVariant, timeIncrement, initialFen: _fromPositionFen);
                    Navigator.pop(context);
                  }
                : null,
            child: Text(context.l10n.play, style: Styles.bold),
          ),
        ),
      ],
    );
  }
}

void showConfigureDisplaySettings(BuildContext context) {
  showModalBottomSheet<void>(
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
          onChanged: (_) =>
              ref.read(overTheBoardPreferencesProvider.notifier).toggleSymmetricPieces(),
        ),
        SwitchSettingTile(
          title: const Text('Flip pieces and opponent info after move'),
          value: prefs.flipPiecesAfterMove,
          onChanged: (_) =>
              ref.read(overTheBoardPreferencesProvider.notifier).toggleFlipPiecesAfterMove(),
        ),
      ],
    );
  }
}

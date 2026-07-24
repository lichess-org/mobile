import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/clock/clock_tool_controller.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/clock/clock_tool_l10n.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

const _addTimeAmounts = [Duration(seconds: 10), Duration(seconds: 30), Duration(minutes: 1)];

class ClockToolSettingsModal extends StatefulWidget {
  const ClockToolSettingsModal({
    required this.clockType,
    required this.timeIncrement,
    required this.started,
    required this.onClockTypeSelected,
    required this.onTimeSelected,
    required this.onAddTime,
    super.key,
  });

  final ClockTimeControlType clockType;
  final TimeIncrement timeIncrement;
  final bool started;
  final ValueSetter<ClockTimeControlType> onClockTypeSelected;
  final ValueSetter<TimeIncrement> onTimeSelected;
  final void Function(ClockSide playerType, Duration duration) onAddTime;

  @override
  State<ClockToolSettingsModal> createState() => _ClockToolSettingsModalState();
}

class _ClockToolSettingsModalState extends State<ClockToolSettingsModal> {
  late ClockTimeControlType _clockType;
  late TimeIncrement _timeIncrement;
  ClockSide _playerType = ClockSide.bottom;

  @override
  void initState() {
    super.initState();
    _clockType = widget.clockType;
    _timeIncrement = widget.timeIncrement;
  }

  void _setClockType(ClockTimeControlType type) {
    setState(() => _clockType = type);
  }

  void _setTotalTime(num seconds) {
    setState(() {
      _timeIncrement = TimeIncrement(seconds.toInt(), _timeIncrement.increment);
    });
  }

  void _setIncrement(num seconds) {
    setState(() {
      _timeIncrement = TimeIncrement(_timeIncrement.time, seconds.toInt());
    });
  }

  void _addTime(BuildContext context, ClockSide playerType, Duration duration) {
    widget.onAddTime(playerType, duration);
    Navigator.of(context).pop();
  }

  void _submit(BuildContext context) {
    widget.onClockTypeSelected(_clockType);
    widget.onTimeSelected(_timeIncrement);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetScrollableContainer(
      padding: Styles.bodyPadding,
      children: [
        if (!widget.started)
          ListSection(
            materialFilledCard: true,
            children: [
              SettingsListTile(
                settingsLabel: Text(context.l10n.timeControl),
                settingsValue: _clockType.label(context.l10n),
                onTap: () {
                  showChoicePicker<ClockTimeControlType>(
                    context,
                    title: Text(context.l10n.timeControl),
                    choices: ClockTimeControlType.values,
                    selectedItem: _clockType,
                    labelBuilder: (type) => Text(type.label(context.l10n)),
                    onSelectedItemChanged: _setClockType,
                  );
                },
              ),
              ListTile(
                title: Text.rich(
                  TextSpan(
                    text: '${context.l10n.minutesPerSide}: ',
                    children: [
                      TextSpan(
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        text: clockLabelInMinutes(_timeIncrement.time),
                      ),
                    ],
                  ),
                ),
                subtitle: NonLinearSlider(
                  value: _timeIncrement.time,
                  values: kAvailableTimesInSeconds,
                  labelBuilder: clockLabelInMinutes,
                  onChange: _setTotalTime,
                  onChangeEnd: _setTotalTime,
                ),
              ),
              ListTile(
                title: Text.rich(
                  TextSpan(
                    text: '${_clockType.valueInSecondsLabel(context.l10n)}: ',
                    children: [
                      TextSpan(
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        text: _timeIncrement.increment.toString(),
                      ),
                    ],
                  ),
                ),
                subtitle: NonLinearSlider(
                  value: _timeIncrement.increment,
                  values: kAvailableIncrementsInSeconds,
                  onChange: _setIncrement,
                  onChangeEnd: _setIncrement,
                ),
              ),
            ],
          ),
        if (widget.started) ...[
          const SettingsSectionTitle('Add time'),
          ListSection(
            materialFilledCard: true,
            children: [
              SettingsListTile(
                settingsLabel: const Text('Player'),
                settingsValue: _playerLabel(context, _playerType),
                onTap: () {
                  showChoicePicker<ClockSide>(
                    context,
                    title: const Text('Player'),
                    choices: ClockSide.values,
                    selectedItem: _playerType,
                    labelBuilder: (playerType) => Text(_playerLabel(context, playerType)),
                    onSelectedItemChanged: (playerType) {
                      setState(() => _playerType = playerType);
                    },
                  );
                },
              ),
              for (final duration in _addTimeAmounts)
                ListTile(
                  title: Text(_addTimeLabel(duration)),
                  onTap: () => _addTime(context, _playerType, duration),
                ),
            ],
          ),
        ],
        Padding(
          padding: Styles.horizontalBodyPadding,
          child: FilledButton(
            onPressed: widget.started ? () => Navigator.of(context).pop() : () => _submit(context),
            child: Text(
              widget.started ? context.l10n.close : context.l10n.mobileOkButton,
              style: Styles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

String _playerLabel(BuildContext context, ClockSide playerType) {
  return playerType == ClockSide.top ? 'Top' : 'Bottom';
}

String _addTimeLabel(Duration duration) {
  final seconds = duration.inSeconds;
  if (seconds % 60 == 0) {
    return '+${seconds ~/ 60}m';
  }
  return '+${seconds}s';
}

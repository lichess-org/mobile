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

class ClockToolSettingsModal extends StatefulWidget {
  const ClockToolSettingsModal({
    required this.clockType,
    required this.timeIncrement,
    required this.onClockTypeSelected,
    required this.onTimeSelected,
    super.key,
  });

  final ClockTimeControlType clockType;
  final TimeIncrement timeIncrement;
  final ValueSetter<ClockTimeControlType> onClockTypeSelected;
  final ValueSetter<TimeIncrement> onTimeSelected;

  @override
  State<ClockToolSettingsModal> createState() => _ClockToolSettingsModalState();
}

class _ClockToolSettingsModalState extends State<ClockToolSettingsModal> {
  late ClockTimeControlType _clockType;
  late TimeIncrement _timeIncrement;

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

  void _submit(BuildContext context) {
    widget.onClockTypeSelected(_clockType);
    widget.onTimeSelected(_timeIncrement);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetScrollableContainer(
      children: [
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
        Padding(
          padding: Styles.horizontalBodyPadding,
          child: FilledButton(
            onPressed: () => _submit(context),
            child: Text(context.l10n.mobileOkButton, style: Styles.bold),
          ),
        ),
      ],
    );
  }
}

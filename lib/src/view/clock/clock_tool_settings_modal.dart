import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/clock/clock_tool_controller.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/clock/clock_time_sliders.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
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
    widget.onClockTypeSelected(type);
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

  void _applyTotalTime(num seconds) {
    final timeIncrement = TimeIncrement(seconds.toInt(), _timeIncrement.increment);
    setState(() => _timeIncrement = timeIncrement);
    widget.onTimeSelected(timeIncrement);
  }

  void _applyIncrement(num seconds) {
    final timeIncrement = TimeIncrement(_timeIncrement.time, seconds.toInt());
    setState(() => _timeIncrement = timeIncrement);
    widget.onTimeSelected(timeIncrement);
  }

  String _clockValueInSecondsLabel(BuildContext context) {
    return switch (_clockType) {
      ClockTimeControlType.increment => context.l10n.incrementInSeconds,
      ClockTimeControlType.simpleDelay || ClockTimeControlType.bronsteinDelay => 'Delay in seconds',
    };
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetScrollableContainer(
      children: [
        ListSection(
          materialFilledCard: true,
          children: [
            SettingsListTile(
              settingsLabel: const Text('Clock type'),
              settingsValue: _clockType.label,
              onTap: () {
                showChoicePicker<ClockTimeControlType>(
                  context,
                  title: const Text('Clock type'),
                  choices: ClockTimeControlType.values,
                  selectedItem: _clockType,
                  labelBuilder: (type) => Text(type.label),
                  onSelectedItemChanged: _setClockType,
                );
              },
            ),
            ...clockTimeSliderTiles(
              context,
              timeIncrement: _timeIncrement,
              incrementLabel: _clockValueInSecondsLabel(context),
              onTimeChange: _setTotalTime,
              onTimeChangeEnd: _applyTotalTime,
              onIncrementChange: _setIncrement,
              onIncrementChangeEnd: _applyIncrement,
            ),
          ],
        ),
      ],
    );
  }
}

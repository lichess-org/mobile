import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/clock/clock_tool_controller.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/clock/clock_time_sliders.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/list.dart';

class CustomClockSettings extends StatefulWidget {
  const CustomClockSettings({
    required this.clockType,
    required this.clock,
    required this.onTimeSelected,
  });

  final ClockTimeControlType clockType;
  final TimeIncrement clock;
  final ValueSetter<TimeIncrement> onTimeSelected;

  @override
  State<CustomClockSettings> createState() => _CustomClockSettingsState();
}

class _CustomClockSettingsState extends State<CustomClockSettings> {
  late TimeIncrement _clock;

  @override
  void initState() {
    super.initState();
    _clock = widget.clock;
  }

  void _setTotalTime(num seconds) {
    setState(() {
      _clock = TimeIncrement(seconds.toInt(), _clock.increment);
    });
  }

  void _setIncrement(num seconds) {
    setState(() {
      _clock = TimeIncrement(_clock.time, seconds.toInt());
    });
  }

  void _submit(BuildContext context) {
    widget.onTimeSelected(_clock);
    Navigator.of(context).pop();
  }

  String _clockValueInSecondsLabel(BuildContext context) {
    return switch (widget.clockType) {
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
            ...clockTimeSliderTiles(
              context,
              timeIncrement: _clock,
              timeLabel: 'Minutes',
              incrementLabel: _clockValueInSecondsLabel(context),
              onTimeChange: _setTotalTime,
              onTimeChangeEnd: _setTotalTime,
              onIncrementChange: _setIncrement,
              onIncrementChangeEnd: _setIncrement,
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

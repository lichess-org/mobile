import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/clock/clock_tool_controller.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/clock/clock_tool_l10n.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';

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

  @override
  Widget build(BuildContext context) {
    return BottomSheetScrollableContainer(
      children: [
        ListSection(
          materialFilledCard: true,
          children: [
            ListTile(
              title: Text.rich(
                TextSpan(
                  text: '${context.l10n.minutesPerSide}: ',
                  children: [
                    TextSpan(
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      text: clockLabelInMinutes(_clock.time),
                    ),
                  ],
                ),
              ),
              subtitle: NonLinearSlider(
                value: _clock.time,
                values: kAvailableTimesInSeconds,
                labelBuilder: clockLabelInMinutes,
                onChange: _setTotalTime,
                onChangeEnd: _setTotalTime,
              ),
            ),
            ListTile(
              title: Text.rich(
                TextSpan(
                  text: '${widget.clockType.valueInSecondsLabel(context.l10n)}: ',
                  children: [
                    TextSpan(
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      text: _clock.increment.toString(),
                    ),
                  ],
                ),
              ),
              subtitle: NonLinearSlider(
                value: _clock.increment,
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

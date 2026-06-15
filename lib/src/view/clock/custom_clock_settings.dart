import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/clock/clock_tool_controller.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';

class CustomClockSettings extends StatefulWidget {
  const CustomClockSettings({required this.onSubmit, required this.player, required this.clock});

  final ClockSide player;
  final TimeIncrement clock;
  final void Function(ClockSide player, TimeIncrement clock) onSubmit;

  @override
  State<CustomClockSettings> createState() => _CustomClockSettingsState();
}

class _CustomClockSettingsState extends State<CustomClockSettings> {
  late int time;
  late int increment;
  late int delay;

  @override
  void initState() {
    time = widget.clock.time;
    increment = widget.clock.increment;
    delay = widget.clock.delay;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetScrollableContainer(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      children: [
        _PlayerTimeSlider(
          clock: TimeIncrement(time, increment, delay: delay),
          updateTime: (int t) => setState(() => time = t),
          updateIncrement: (int inc) => setState(() => increment = inc),
          updateDelay: (int d) => setState(() => delay = d),
        ),
        Padding(
          padding: Styles.horizontalBodyPadding,
          child: FilledButton(
            child: Text(context.l10n.apply),
            onPressed: () =>
                widget.onSubmit(widget.player, TimeIncrement(time, increment, delay: delay)),
          ),
        ),
      ],
    );
  }
}

class _PlayerTimeSlider extends StatelessWidget {
  const _PlayerTimeSlider({
    required this.clock,
    required this.updateTime,
    required this.updateIncrement,
    required this.updateDelay,
  });

  final TimeIncrement clock;
  final void Function(int time) updateTime;
  final void Function(int time) updateIncrement;
  final void Function(int delay) updateDelay;

  @override
  Widget build(BuildContext context) {
    return ListSection(
      children: [
        NonLinearSliderTile(
          title: Text(
            '${context.l10n.time}: ${clock.time < 60 ? context.l10n.nbSeconds(clock.time) : context.l10n.nbMinutes(_secToMin(clock.time))}',
          ),
          value: clock.time,
          values: kAvailableTimesInSeconds,
          labelBuilder: _clockTimeLabel,
          onChanged: updateTime,
        ),
        NonLinearSliderTile(
          title: Text('${context.l10n.increment}: ${context.l10n.nbSeconds(clock.increment)}'),
          value: clock.increment,
          values: kAvailableIncrementsInSeconds,
          labelBuilder: (num sec) => sec.toString(),
          onChanged: updateIncrement,
        ),
        NonLinearSliderTile(
          title: Text('Delay: ${context.l10n.nbSeconds(clock.delay)}'),
          value: clock.delay,
          values: kAvailableIncrementsInSeconds,
          labelBuilder: (num sec) => sec.toString(),
          onChanged: updateDelay,
        ),
      ],
    );
  }
}

int _secToMin(num sec) => sec ~/ 60;

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
      return _secToMin(seconds).toString();
  }
}

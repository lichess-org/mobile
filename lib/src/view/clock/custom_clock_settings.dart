import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';

class CustomClockSettings extends StatefulWidget {
  const CustomClockSettings({super.key, required this.onSubmit, required this.player, required this.clock});

  final Side player;
  final TimeIncrement clock;
  final void Function(Side player, TimeIncrement clock) onSubmit;

  @override
  State<CustomClockSettings> createState() => _CustomClockSettingsState();
}

class _CustomClockSettingsState extends State<CustomClockSettings> {
  late int time;
  late int increment;

  @override
  void initState() {
    time = widget.clock.time;
    increment = widget.clock.increment;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetScrollableContainer(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      children: [
        _PlayerTimeSlider(
          clock: TimeIncrement(time, increment),
          updateTime: (int t) => setState(() => time = t),
          updateIncrement: (int inc) => setState(() => increment = inc),
        ),
        Padding(
          padding: Styles.horizontalBodyPadding,
          child: FatButton(
            semanticsLabel: context.l10n.apply,
            child: Text(context.l10n.apply),
            onPressed: () => widget.onSubmit(widget.player, TimeIncrement(time, increment)),
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
  });

  final TimeIncrement clock;
  final void Function(int time) updateTime;
  final void Function(int time) updateIncrement;

  @override
  Widget build(BuildContext context) {
    return ListSection(
      children: [
        PlatformListTile(
          title: Text(
            '${context.l10n.time}: ${clock.time < 60 ? context.l10n.nbSeconds(clock.time) : context.l10n.nbMinutes(_secToMin(clock.time))}',
          ),
          subtitle: NonLinearSlider(
            value: clock.time,
            values: kAvailableTimesInSeconds,
            labelBuilder: _clockTimeLabel,
            onChange:
                Theme.of(context).platform == TargetPlatform.iOS
                    ? (num value) {
                      updateTime(value.toInt());
                    }
                    : null,
            onChangeEnd: (num value) {
              updateTime(value.toInt());
            },
          ),
        ),
        PlatformListTile(
          title: Text('${context.l10n.increment}: ${context.l10n.nbSeconds(clock.increment)}'),
          subtitle: NonLinearSlider(
            value: clock.increment,
            values: kAvailableIncrementsInSeconds,
            labelBuilder: (num sec) => sec.toString(),
            onChange:
                Theme.of(context).platform == TargetPlatform.iOS
                    ? (num value) {
                      updateIncrement(value.toInt());
                    }
                    : null,
            onChangeEnd: (num value) {
              updateIncrement(value.toInt());
            },
          ),
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

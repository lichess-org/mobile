import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';

List<Widget> clockTimeSliderTiles(
  BuildContext context, {
  required TimeIncrement timeIncrement,
  required ValueChanged<num> onTimeChange,
  required ValueChanged<num> onTimeChangeEnd,
  required ValueChanged<num> onIncrementChange,
  required ValueChanged<num> onIncrementChangeEnd,
  String? timeLabel,
  String? incrementLabel,
}) {
  return [
    ListTile(
      title: Text.rich(
        TextSpan(
          text: '${timeLabel ?? context.l10n.minutesPerSide}: ',
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
        onChange: onTimeChange,
        onChangeEnd: onTimeChangeEnd,
      ),
    ),
    ListTile(
      title: Text.rich(
        TextSpan(
          text: '${incrementLabel ?? context.l10n.incrementInSeconds}: ',
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
        onChange: onIncrementChange,
        onChangeEnd: onIncrementChangeEnd,
      ),
    ),
  ];
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/clock/clock_controller.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

import '../../styles/styles.dart';

class CustomTimeControlModal extends ConsumerWidget{
  final void Function() onSet;


  const CustomTimeControlModal({
    required this.onSet,
});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int topClockTime = 0;
    int topClockIncrement= 0;
    int bottomClockTime = 0;
    int bottomClockIncrement = 0;
    const int secondsPerMinute = 60;
    final controller = ref.read(clockControllerProvider.notifier);

    return SafeArea(child: Padding(
    padding: Styles.bodyPadding,
    child:  ListView(
      shrinkWrap: true,
      children: [
        Text(
          context.l10n.timeControl,
          style: Styles.title,
        ),
        const SizedBox(height: 20.0),
        _SectionTimeControlSelector(sectionTitle: 'Top clock',
            onTimeChange: (int value)=>{topClockTime =value},
            onIncrementChange: (int value)=>{topClockIncrement =value},
        ),
        const SizedBox(height: 15.0),
        _SectionTimeControlSelector(sectionTitle: 'Bottom clock',
            onTimeChange: (int value)=>{bottomClockTime =value},
            onIncrementChange: (int value)=>{bottomClockIncrement =value}
          ,),
        const SizedBox(height: 15.0,),
        Center(
          child: SecondaryButton(semanticsLabel: 'Set custom time control',
              child: const Text('Start'),
            onPressed: (){
            controller.updateOptions(
              TimeIncrement(topClockTime*secondsPerMinute, topClockIncrement),
              TimeIncrement(bottomClockTime*secondsPerMinute, bottomClockIncrement),
            );
            Navigator.pop(context);
            onSet();},
          ),
        ),
      ],

    ),
    ),
    );
  }

}
class _SectionTimeControlSelector extends StatelessWidget{
  final String sectionTitle;
  final Set<int> Function(int) onTimeChange;
  final Set<int> Function(int) onIncrementChange;

  const _SectionTimeControlSelector({
    required this.sectionTitle,
    required this.onTimeChange,
    required this.onIncrementChange,
});

  @override
  Widget build(BuildContext context) {
  return  ListView(
    shrinkWrap: true,
    children: [
      Text(sectionTitle,
        style: Styles.mainListTileTitle,
      ),
      const SizedBox(height: 10.0),
      _TimerSlider(title: 'Time in minutes',
          min: 0.0,
          max: 180.0,
          onChange: onTimeChange,),
      _TimerSlider(title: 'Increment in seconds',
          min: 0.0,
          max: 180.0,
          onChange: onIncrementChange,),
    ],
  );
  }
}
class _TimerSlider extends StatefulWidget{
  final String title;
  final double min;
  final double max;
  final void Function(int) onChange;
  const _TimerSlider({
    required this.title,
    required this.min,
    required this.max,
    required this.onChange,
  });

  @override
  State<_TimerSlider> createState() => _TimerSliderState();
}
class _TimerSliderState extends State<_TimerSlider>{
  double _value =0.0;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${widget.title}: ${_value.round()}',
          style: Styles.subtitle,
        ),
        SliderTheme(data: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.always,
          trackHeight: 10.0,
        ), child: Slider.adaptive(value: _value,
          min: widget.min,
          max:widget.max,
          divisions: (widget.max-widget.min).round(),
          label: _value.round().toString(),
          onChanged: (newValue){
          setState(() {
            _value = newValue;
          });

          widget.onChange(newValue.round());
        },
        ),
        ),
      ],
    );
  }
}

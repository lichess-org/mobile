import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Wrapper over [Slider] to allow backing the slider by [SharedPreferences].
class PrefSlider extends ConsumerStatefulWidget {
  const PrefSlider(
      {required this.initialValue,
      required this.min,
      required this.max,
      this.divisions,
      required this.makeLabel,
      this.isDisabled = false,
      required this.onChangeEnd,
      Key? key})
      : super(key: key);

  final num initialValue;
  final bool isDisabled;
  final double min;
  final double max;
  final int? divisions;
  final String Function(double value) makeLabel;
  final void Function(double value) onChangeEnd;

  @override
  ConsumerState<PrefSlider> createState() => _PrefSliderState();
}

class _PrefSliderState extends ConsumerState<PrefSlider> {
  double _value = 0;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _value,
      min: widget.min,
      max: widget.max,
      divisions: widget.divisions,
      label: widget.makeLabel(_value),
      onChanged: widget.isDisabled
          ? null
          : (double newVal) {
              setState(() {
                _value = newVal;
              });
            },
      onChangeEnd: widget.onChangeEnd,
    );
  }
}

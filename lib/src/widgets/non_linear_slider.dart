import 'package:flutter/material.dart';

/// Platform adaptive slider that allows for non-linear values.
class NonLinearSlider extends StatefulWidget {
  NonLinearSlider({
    required this.value,
    required this.values,
    this.labelBuilder,
    this.onChange,
    this.onChangeEnd,
    super.key,
  }) : assert(values.length > 1),
       assert(values.contains(value));

  final num value;
  final List<num> values;

  /// Called during a drag when the user is selecting a new value.
  final void Function(num)? onChange;

  /// Called when the user is done selecting a value. If null, the widget will
  /// be disabled.
  final ValueChanged<num>? onChangeEnd;

  final String Function(num)? labelBuilder;

  @override
  State<NonLinearSlider> createState() => _NonLinearSliderState();
}

class _NonLinearSliderState extends State<NonLinearSlider> {
  int _index = 0;

  @override
  void initState() {
    _index = widget.values.indexOf(widget.value);
    super.initState();
  }

  @override
  void didUpdateWidget(NonLinearSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    _index = widget.values.indexOf(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity:
          Theme.of(context).platform != TargetPlatform.iOS || widget.onChangeEnd != null ? 1 : 0.5,
      child: Slider.adaptive(
        value: _index.toDouble(),
        min: 0,
        max: widget.values.length.toDouble() - 1,
        divisions: widget.values.length - 1,
        label: widget.labelBuilder?.call(widget.values[_index]) ?? widget.values[_index].toString(),
        onChanged:
            widget.onChangeEnd != null
                ? (double value) {
                  final newIndex = value.toInt();
                  setState(() {
                    _index = newIndex;
                  });

                  widget.onChange?.call(widget.values[_index]);
                }
                : null,
        onChangeEnd: (double value) {
          widget.onChangeEnd?.call(widget.values[_index]);
        },
      ),
    );
  }
}

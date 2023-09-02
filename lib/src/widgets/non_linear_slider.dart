import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Platform adaptive slider that allows for non-linear values.
class NonLinearSlider extends StatefulWidget {
  NonLinearSlider({
    required this.value,
    required this.values,
    this.labelBuilder,
    this.onChangeEnd,
    super.key,
  })  : assert(values.length > 1),
        assert(values.contains(value));

  final num value;
  final List<num> values;

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
    return Slider.adaptive(
      value: _index.toDouble(),
      min: 0,
      max: widget.values.length.toDouble() - 1,
      divisions: widget.values.length - 1,
      label: widget.labelBuilder?.call(widget.values[_index]) ??
          widget.values[_index].toString(),
      onChanged: widget.onChangeEnd != null
          ? (double value) {
              final currentIndex = _index;
              final newIndex = value.toInt();
              setState(() {
                _index = newIndex;
              });

              // iOS doesn't show a label when sliding, so we need to manually
              // call the callback when the value changes.
              if (defaultTargetPlatform == TargetPlatform.iOS &&
                  currentIndex != newIndex &&
                  widget.onChangeEnd != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  widget.onChangeEnd?.call(widget.values[_index]);
                });
              }
            }
          : null,
      onChangeEnd: (double value) {
        if (defaultTargetPlatform != TargetPlatform.iOS) {
          widget.onChangeEnd?.call(widget.values[_index]);
        }
      },
    );
  }
}

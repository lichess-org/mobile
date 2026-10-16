import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoSlidingSegmentedControl;
import 'package:lichess_mobile/src/widgets/platform.dart' show useLiquidGlass;
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassSegment, GlassSegmentedControl;
import 'package:material_ui/material_ui.dart';

/// A single choice segmented control: a Material [SegmentedButton] on Android, a liquid glass
/// segmented control on iOS (a plain one before iOS 26).
class const PlatformSegmentedControl<T extends Object>({
  super.key,

  /// The value and label of each segment.
  required final List<(T value, String label)> segments,

  /// The value of the selected segment.
  required final T selected,

  /// Called with the value of the segment the user selects.
  required final ValueChanged<T> onChanged,

  /// Passed to [SegmentedButton.showSelectedIcon] on Android. iOS segments have no icon.
  final bool showSelectedIcon = true,

  /// Passed to [SegmentedButton.expandedInsets] on Android, where it makes the control fill the
  /// width. On iOS the control always fills the width, and these insets are kept around it.
  final EdgeInsets? expandedInsets,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS && !useLiquidGlass(context)) {
      return Padding(
        padding: expandedInsets ?? EdgeInsets.zero,
        child: SizedBox(
          width: double.infinity,
          child: CupertinoSlidingSegmentedControl<T>(
            groupValue: selected,
            children: {
              for (final (value, label) in segments)
                value: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            },
            onValueChanged: (value) {
              if (value != null) onChanged(value);
            },
          ),
        ),
      );
    }

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return Padding(
        padding: expandedInsets ?? EdgeInsets.zero,
        child: GlassSegmentedControl(
          segments: [for (final (_, label) in segments) GlassSegment(label: label)],
          selectedIndex: segments.indexWhere((segment) => segment.$1 == selected),
          onSegmentSelected: (index) => onChanged(segments[index].$1),
          // Shown in a sheet or a page, there is no parent glass layer to share.
          useOwnLayer: true,
        ),
      );
    }

    return SegmentedButton<T>(
      segments: [
        for (final (value, label) in segments) ButtonSegment(value: value, label: Text(label)),
      ],
      selected: {selected},
      showSelectedIcon: showSelectedIcon,
      expandedInsets: expandedInsets,
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}

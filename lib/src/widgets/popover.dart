import 'package:material_ui/material_ui.dart';
import 'package:popover/popover.dart' as popover;

export 'package:popover/popover.dart' show PopoverDirection, PopoverTransition;

/// Shows a popover anchored to the widget at [context].
///
/// Always use this instead of `popover`'s own `showPopover`.
///
/// The parameters mirror `showPopover`, minus the ones the app has no use for.
Future<T?> showPopover<T extends Object?>({
  required BuildContext context,
  required WidgetBuilder bodyBuilder,
  required Color backgroundColor,
  popover.PopoverDirection direction = popover.PopoverDirection.bottom,
  Color barrierColor = const Color(0x80000000),
  Duration transitionDuration = const Duration(milliseconds: 200),
  List<BoxShadow> shadow = const [BoxShadow(color: Color(0x1F000000), blurRadius: 5)],
  double arrowWidth = 24,
  double arrowHeight = 12,
  double? width,
  double? height,
  Widget Function(Animation<double> animation, Widget child)? popoverTransitionBuilder,
}) {
  return popover.showPopover<T>(
    context: context,
    bodyBuilder: bodyBuilder,
    direction: direction,
    backgroundColor: backgroundColor,
    barrierColor: barrierColor,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    transitionDuration: transitionDuration,
    shadow: shadow,
    arrowWidth: arrowWidth,
    arrowHeight: arrowHeight,
    width: width,
    height: height,
    popoverTransitionBuilder: popoverTransitionBuilder,
  );
}

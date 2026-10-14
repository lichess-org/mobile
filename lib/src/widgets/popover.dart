import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' show GlassPopover;
import 'package:material_ui/material_ui.dart';
import 'package:popover/popover.dart' as popover;

export 'package:popover/popover.dart' show PopoverDirection, PopoverTransition;

/// Shows a `popover` popover anchored to the widget at [context], for [PlatformPopover].
///
/// The parameters mirror `popover`'s own `showPopover`, minus the ones the app has no use for.
Future<T?> _showPopover<T extends Object?>({
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
    // `popover` wraps the body in Flutter's own [Material], which `material_ui` widgets do not
    // recognize, so provide one they do. It is transparent because `popover` already paints
    // [backgroundColor] behind it.
    bodyBuilder: (context) =>
        Material(type: MaterialType.transparency, child: bodyBuilder(context)),
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

/// A widget that shows a popover anchored to it: a liquid glass popover that morphs out of the
/// trigger on iOS, like on iOS 26, and a `popover` popover elsewhere.
class const PlatformPopover({
  /// Builds the trigger, which calls `showPopover` to show the popover.
  required final Widget Function(BuildContext context, VoidCallback showPopover) triggerBuilder,
  required final WidgetBuilder bodyBuilder,

  /// The width of the popover. On Android it defaults to the width of the body; on iOS, where the
  /// glass popover needs a fixed width, to a small popover.
  final double? width,

  /// Where the popover is shown on Android. On iOS its position is chosen from the trigger's
  /// position on screen.
  final popover.PopoverDirection direction = popover.PopoverDirection.bottom,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return GlassPopover(
        popoverWidth: width ?? 180.0,
        settings: Theme.of(context).brightness == Brightness.light ? kLightMenuGlassSettings : null,
        // The trigger is not glass itself (e.g. it sits in the glass capsule of the app bar).
        triggerBuilder: triggerBuilder,
        // The glass popover is outside of any Material.
        contentBuilder: (context, _) =>
            Material(type: MaterialType.transparency, child: bodyBuilder(context)),
      );
    }

    // The trigger's own context, to anchor the popover to it.
    return Builder(
      builder: (context) => triggerBuilder(
        context,
        () => _showPopover<void>(
          context: context,
          bodyBuilder: bodyBuilder,
          direction: direction,
          width: width,
          backgroundColor:
              DialogTheme.of(context).backgroundColor ??
              ColorScheme.of(context).surfaceContainerHigh,
          transitionDuration: Duration.zero,
          popoverTransitionBuilder: (_, child) => child,
        ),
      ),
    );
  }
}

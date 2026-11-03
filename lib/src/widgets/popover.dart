import 'package:lichess_mobile/src/widgets/glass_modal.dart' show opaqueModalColor;
import 'package:lichess_mobile/src/widgets/platform.dart' show ios27GlassSettings, useLiquidGlass;
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' show GlassPopover;
import 'package:material_ui/material_ui.dart';
import 'package:popover/popover.dart' as popover;

export 'package:popover/popover.dart' show PopoverDirection, PopoverTransition;

/// A widget that shows a popover anchored to it: a liquid glass popover that morphs out of the
/// trigger on iOS 26 and later, and an opaque `popover` popover elsewhere.
class const PlatformPopover({
  /// Builds the trigger, which calls `showPopover` to show the popover.
  required final Widget Function(BuildContext context, VoidCallback showPopover) triggerBuilder,
  required final WidgetBuilder bodyBuilder,

  /// The width of the popover. It defaults to the width of the body, except for the glass popover
  /// (iOS 26 and later), which needs a fixed width: a small popover.
  final double? width,

  /// Where the popover is shown. The glass popover (iOS 26 and later) chooses its position from the
  /// trigger's position on screen.
  final popover.PopoverDirection direction = popover.PopoverDirection.bottom,

  /// Whether the glass popover (iOS 26 and later) has an opaque fill ([opaqueModalColor]), for a
  /// body that would be hard to read on glass over busy content. It keeps the glass shape and its
  /// morph out of the trigger. The other popovers are always opaque.
  final bool opaque = false,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (useLiquidGlass(context)) {
      return GlassPopover(
        popoverWidth: width ?? 180.0,
        settings: opaque
            // The glass, with an opaque fill.
            ? ios27GlassSettings(context).copyWith(glassColor: opaqueModalColor(context))
            : ios27GlassSettings(context),
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
        () => popover.showPopover<void>(
          context: context,
          // `popover` does not wrap the body in a [Material], which `material_ui` widgets need. It
          // is transparent because `popover` already paints the background behind it.
          bodyBuilder: (context) =>
              Material(type: MaterialType.transparency, child: bodyBuilder(context)),
          direction: direction,
          width: width,
          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
          style: popover.PopoverStyle(
            // The plain shape on every platform: the glass popover covers iOS 26 and later.
            arrowStyle: .triangle,
            // Like a card, so that it stands out from the background.
            backgroundColor:
                DialogTheme.of(context).backgroundColor ??
                CardTheme.of(context).color ??
                ColorScheme.of(context).surfaceContainerHigh,
            transitionDuration: Duration.zero,
          ),
          popoverTransitionBuilder: (_, child) => child,
        ),
      ),
    );
  }
}

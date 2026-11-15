import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoDialogRoute;
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassContainer, LiquidRoundedSuperellipse;
import 'package:material_ui/material_ui.dart';

/// The color of the opaque iOS modals: the color of the Material sheets, without their
/// translucency.
Color opaqueModalColor(BuildContext context) =>
    Theme.of(context).bottomSheetTheme.backgroundColor?.withValues(alpha: 1.0) ??
    ColorScheme.of(context).surfaceContainerLow;

/// The rounded liquid glass card of an iOS modal (action sheet, alert dialog, bottom sheet).
///
/// With [tinted], its glass is nearly opaque, for a modal shown over busy content such as a board,
/// which the glass would let show through too much. It is tinted with [opaqueModalColor] in dark
/// mode, and with the neutral color of the glass in light mode: there, the theme color would look
/// too warm, and the glass only keeps a light color bright when it is neutral (a color with a hue
/// takes the brightness of the dimmed content behind the modal).
///
/// With [opaque], or before iOS 26 ([useLiquidGlass]), it is an opaque card ([opaqueModalColor]) of
/// the same shape.
class const GlassModalCard({
  required final Widget child,
  final double borderRadius = 26.0,
  final EdgeInsetsGeometry? padding,
  final bool tinted = false,

  /// Whether the card is fully opaque, for a modal whose content must not mix with the content
  /// behind it at all (e.g. a game result over the board).
  final bool opaque = false,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!useLiquidGlass(context) || opaque) {
      return Material(
        color: opaqueModalColor(context),
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        clipBehavior: Clip.antiAlias,
        child: padding != null ? Padding(padding: padding!, child: child) : child,
      );
    }

    return GlassContainer(
      // A modal floats alone over the content, there is no parent glass layer to share.
      useOwnLayer: true,
      shape: LiquidRoundedSuperellipse(borderRadius: borderRadius),
      clipBehavior: Clip.antiAlias,
      padding: padding,
      settings: tinted
          ? ios27GlassSettings(context).copyWith(
              glassColor:
                  (Theme.of(context).brightness == .light
                          ? ios27GlassSettings(context).glassColor
                          : opaqueModalColor(context))
                      .withValues(alpha: 0.85),
            )
          : ios27GlassSettings(context),
      child: child,
    );
  }
}

/// The iOS frame of a dialog: a [GlassModalCard] centered on the screen.
///
/// The card is always [GlassModalCard.tinted]: a dialog is read in one go and may be shown over
/// any content, including a board, which would show through the default glass too much.
///
/// With liquid glass, the card is painted through an [OverlayPortal], outside the dialog route's
/// transition: the iOS dialog route ([showAdaptiveDialog]) fades its page in, which would show the
/// glass more transparent until the end of the fade. The card scales in at full opacity instead,
/// and fades out when the dialog closes. An [opaque] card has no glass, and keeps the route's
/// transition.
class const GlassDialogFrame({
  required final Widget child,

  /// The width of an alert dialog by default.
  final double maxWidth = 300.0,

  /// See [GlassModalCard.opaque].
  final bool opaque = false,
  super.key,
}) extends StatefulWidget {
  @override
  State<GlassDialogFrame> createState() => _GlassDialogFrameState();
}

class _GlassDialogFrameState() extends State<GlassDialogFrame> {
  final _portalController = OverlayPortalController();

  /// The scale of the iOS dialog transition ([CupertinoDialogRoute]).
  static final _scaleTween = Tween<double>(begin: 1.3, end: 1.0);

  @override
  void initState() {
    super.initState();
    _portalController.show();
  }

  @override
  Widget build(BuildContext context) {
    final frame = SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: widget.maxWidth),
            child: GlassModalCard(
              tinted: true,
              opaque: widget.opaque,
              borderRadius: 34.0,
              padding: const EdgeInsets.all(20.0),
              // The content may hold Material widgets (list tiles, checkboxes, buttons...).
              child: Material(type: MaterialType.transparency, child: widget.child),
            ),
          ),
        ),
      ),
    );

    final animation = ModalRoute.of(context)?.animation;
    if (!useLiquidGlass(context) || widget.opaque || animation == null) {
      return frame;
    }

    return OverlayPortal(
      controller: _portalController,
      overlayChildBuilder: (context) => AnimatedBuilder(
        animation: animation,
        builder: (context, child) => animation.status == AnimationStatus.reverse
            ? Opacity(opacity: animation.value.clamp(0.0, 1.0), child: child)
            : Transform.scale(scale: _scaleTween.evaluate(animation), child: child),
        child: frame,
      ),
    );
  }
}

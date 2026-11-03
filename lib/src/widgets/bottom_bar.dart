import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassButton, LiquidRoundedRectangle;
import 'package:material_ui/material_ui.dart';

/// A bottom bar that can be used in a [Scaffold.bottomNavigationBar].
///
/// The height of the bar is always [kBottomBarHeight] and the font size scale factor is
/// clamped to 1.4.
class BottomBar extends StatelessWidget {
  const new({
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
    this.expandChildren = true,
    this.cupertinoGlass = false,
  });

  const new empty({this.cupertinoGlass = false})
    : children = const [],
      expandChildren = true,
      mainAxisAlignment = MainAxisAlignment.spaceAround;

  /// Children to display in the bottom bar's [Row]. Typically instances of [BottomBarButton].
  final List<Widget> children;

  /// Alignment of the bottom bar's internal row. Defaults to [MainAxisAlignment.spaceAround].
  final MainAxisAlignment mainAxisAlignment;

  /// Whether to expand the children to fill the available space. Defaults to true.
  final bool expandChildren;

  /// Whether the bar has no background on iOS: its buttons ([BottomBarTextButton],
  /// [BottomBarButton]) are glass capsules that float over the content, evenly spaced and as wide as
  /// their label. Before iOS 26 ([useLiquidGlass]), the bar is translucent instead
  /// ([BlurredBarBackground]), with plain buttons. Defaults to false.
  final bool cupertinoGlass;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final glass = cupertinoGlass && useLiquidGlass(context);
    final bar = BottomAppBar(
      color: isIOS && cupertinoGlass ? Colors.transparent : null,
      elevation: isIOS && cupertinoGlass ? 0.0 : null,
      height: kBottomBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: glass
          // Glass buttons are as wide as their label, and only shrink when they don't fit.
          ? _GlassBottomBarScope(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                spacing: 8.0,
                children: children.map((child) => Flexible(child: child)).toList(),
              ),
            )
          : Row(
              mainAxisAlignment: mainAxisAlignment,
              children: expandChildren
                  ? children.map((child) => Expanded(child: child)).toList()
                  : children,
            ),
    );

    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.4,
      child: isIOS && cupertinoGlass && !glass
          ? BlurredBarBackground(atBottom: true, child: bar)
          : bar,
    );
  }
}

/// A text button in a [BottomBar]: a [TextButton] on Android and before iOS 26, and a liquid glass
/// capsule on iOS, for a bar with [BottomBar.cupertinoGlass].
class const BottomBarTextButton({
  required final VoidCallback? onPressed,
  required final Widget child,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!useLiquidGlass(context)) {
      return TextButton(onPressed: onPressed, child: child);
    }

    return Semantics(
      button: true,
      enabled: onPressed != null,
      child: _GlassBottomBarCapsule(onTap: onPressed, child: child),
    );
  }
}

/// Marks the buttons of a [BottomBar] with [BottomBar.cupertinoGlass] on iOS.
class const _GlassBottomBarScope({required super.child}) extends InheritedWidget {
  static bool isIn(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_GlassBottomBarScope>() != null;

  @override
  bool updateShouldNotify(_GlassBottomBarScope oldWidget) => false;
}

/// A liquid glass capsule button of a [BottomBar] with [BottomBar.cupertinoGlass], as wide as its
/// content.
class const _GlassBottomBarCapsule({
  required final VoidCallback? onTap,
  required final Widget child,
  final bool prominent = false,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final colorScheme = ColorScheme.of(context);
    final foregroundColor = prominent ? colorScheme.primary : colorScheme.onSurface;
    final glassSettings = tintedGlassSettings(context);
    // As wide as its content, within the width the bar gives it.
    return IntrinsicWidth(
      child: Opacity(
        opacity: enabled ? 1.0 : 0.4,
        child: GlassButton.custom(
          onTap: onTap ?? () {},
          enabled: enabled,
          // Tinted for busy content, like boards. A prominent button gets a light wash of the theme
          // color, with a label in that color, like an iOS tinted button.
          settings: prominent
              ? glassSettings.copyWith(
                  glassColor: Color.alphaBlend(
                    // A wash that shows on the light glass as well as on the dark one.
                    colorScheme.primary.withValues(
                      alpha: Theme.of(context).brightness == Brightness.light ? 0.3 : 0.15,
                    ),
                    glassSettings.glassColor,
                  ),
                )
              : glassSettings,
          shape: const LiquidRoundedRectangle(borderRadius: 100),
          // The bar has no glass layer to share.
          useOwnLayer: true,
          width: double.infinity,
          height: 40.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: IconTheme.merge(
              data: IconThemeData(color: foregroundColor, size: 20.0),
              child: DefaultTextStyle.merge(
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: foregroundColor),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A bottom bar button.
///
/// Typically used in a [BottomBar].
class const BottomBarButton({
  required final IconData icon,
  required final String label,
  required final VoidCallback? onTap,
  final String? badgeLabel,
  final bool highlighted = false,
  final bool showLabel = false,
  final bool showTooltip = true,
  final bool blink = false,

  /// Whether the button is the main action of the bar: on iOS, in a [BottomBar] with
  /// [BottomBar.cupertinoGlass], its glass capsule is tinted with the theme color.
  final bool prominent = false,

  /// In case we want to override the tooltip message. If null, the [label] will
  /// be used.
  final String? tooltip,
  super.key,
}) extends StatelessWidget {
  bool get enabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    final primary = ColorScheme.of(context).primary;

    final badge = Badge(
      backgroundColor: ColorScheme.of(context).secondary,
      textStyle: TextStyle(color: ColorScheme.of(context).onSecondary, fontWeight: FontWeight.bold),
      isLabelVisible: badgeLabel != null,
      label: (badgeLabel != null) ? Text(badgeLabel!) : null,
      child: Icon(icon, color: highlighted ? primary : null),
    );

    if (_GlassBottomBarScope.isIn(context)) {
      return Semantics(
        container: true,
        enabled: enabled,
        button: true,
        label: label,
        excludeSemantics: true,
        child: _GlassBottomBarCapsule(
          onTap: onTap,
          prominent: prominent,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            // The badge sticks out to the right of the icon.
            spacing: badgeLabel != null ? 16.0 : 8.0,
            children: [
              badge,
              if (showLabel)
                Flexible(
                  child: Text(
                    label,
                    style: highlighted ? TextStyle(color: primary) : null,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    final labelFontSize = TextTheme.of(context).bodySmall?.fontSize;

    final child = Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          badge,
          if (showLabel)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                label,
                style: TextStyle(fontSize: labelFontSize, color: highlighted ? primary : null),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );

    return Semantics(
      container: true,
      enabled: enabled,
      button: true,
      label: label,
      excludeSemantics: true,
      child: Tooltip(
        excludeFromSemantics: true,
        message: label,
        triggerMode: showTooltip ? TooltipTriggerMode.longPress : TooltipTriggerMode.manual,
        child: InkWell(
          borderRadius: BorderRadius.zero,
          onTap: onTap,
          child: blink
              ? _AnimatedInvertBackground(color: primary.withValues(alpha: 0.2), child: child)
              : child,
        ),
      ),
    );
  }
}

class const _AnimatedInvertBackground({required final Widget child, required final Color color})
    extends StatefulWidget {
  @override
  _InvertBackgroundState createState() => _InvertBackgroundState();
}

class _InvertBackgroundState()
    extends State<_AnimatedInvertBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

    _colorAnimation = ColorTween(begin: Colors.transparent, end: widget.color).animate(_controller)
      ..addStatusListener((status) {
        if (_controller.status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (_controller.status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (_, _) => Container(color: _colorAnimation.value, child: widget.child),
    );
  }
}

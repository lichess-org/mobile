import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassButton, GlassScrollEdgeEffect, LiquidRoundedRectangle;
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

  /// Children to display in the bottom bar's [Row]. Typically instances of [BottomBarButton], or
  /// [BottomBarGroup]s of them.
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

  /// Whether [context] is in a [BottomBar] with liquid glass buttons, for a custom button that
  /// draws itself as a [BottomBarGlassButton] there.
  static bool isGlass(BuildContext context) => _GlassBottomBarScope.isIn(context);

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final glass = cupertinoGlass && useLiquidGlass(context);
    // Without glass, the buttons of a group are laid out like the other buttons.
    final ungrouped = glass
        ? children
        : children.expand((child) => child is BottomBarGroup ? child.children : [child]).toList();
    final bar = BottomAppBar(
      color: isIOS && cupertinoGlass ? Colors.transparent : null,
      elevation: isIOS && cupertinoGlass ? 0.0 : null,
      height: kBottomBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: glass
          ? _GlassBottomBarScope(child: _GlassBarRow(children: children))
          : Row(
              mainAxisAlignment: mainAxisAlignment,
              children: expandChildren
                  ? ungrouped.map((child) => Expanded(child: child)).toList()
                  : ungrouped,
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

/// Strongest blur of the content under a [BottomBar] floating over it, at the bottom of the screen.
const double _kBottomEdgeBlurMaxSigma = 8.0;

/// Opacity of the tint over the bottom edge blur, below the top of the bar buttons, in light and
/// dark mode. The glass buttons stand out less over light content.
const double _kBottomEdgeTintLightOpacity = 0.7;
const double _kBottomEdgeTintDarkOpacity = 0.5;

/// How far above a [BottomBar] floating over the content the bottom edge blur and tint start.
const double _kBottomEdgeFadeAboveBar = 4.0;

/// Distance from the top of a [BottomBar] to the vertical middle of its glass buttons, where the
/// tint over the bottom edge blur reaches its full opacity.
const double _kBottomBarButtonsMiddle = 8.0 + _kGlassCapsuleHeight / 2;

/// Number of stops of the eased tint gradient over the bottom edge blur.
const int _kBottomEdgeTintSteps = 8;

/// The bottom edge of content scrolling under a [BottomBar] with [BottomBar.cupertinoGlass] that
/// floats over it, on iOS 26 and later: the content under the bar is blurred, under a gradient of
/// [color], so that its glass buttons stay readable, like an iOS scroll edge effect.
///
/// Before iOS 26, the bar has its own blur ([BlurredBarBackground]): [child] is shown as is.
class const BottomBarScrollEdgeEffect({
  /// Height of the bar over the content, home indicator included.
  required final double barHeight,

  /// The background color of the content, which tints the edge under the bar buttons.
  required final Color color,
  required final Widget child,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!useLiquidGlass(context)) return child;

    final edgeHeight = barHeight + _kBottomEdgeFadeAboveBar;
    final tintOpacity = Theme.of(context).brightness == Brightness.light
        ? _kBottomEdgeTintLightOpacity
        : _kBottomEdgeTintDarkOpacity;
    // Where the tint reaches its full opacity, as a fraction of the edge height.
    final tintEnd = math.min(
      1.0,
      (_kBottomEdgeFadeAboveBar + _kBottomBarButtonsMiddle) / edgeHeight,
    );
    return Stack(
      children: [
        Positioned.fill(
          child: GlassScrollEdgeEffect(
            style: .blur,
            maxSigma: _kBottomEdgeBlurMaxSigma,
            fadeTop: false,
            bottomFadeHeight: edgeHeight,
            child: child,
          ),
        ),
        // A tint of the content color over the blur, for a little more opacity under the buttons,
        // fading in above them.
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: edgeHeight,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  // A smoothstep from transparent to the full tint, with no visible edge where it
                  // starts or ends.
                  colors: [
                    for (var i = 0; i <= _kBottomEdgeTintSteps; i++)
                      color.withValues(alpha: tintOpacity * _smoothstep(i / _kBottomEdgeTintSteps)),
                  ],
                  stops: [
                    for (var i = 0; i <= _kBottomEdgeTintSteps; i++)
                      i / _kBottomEdgeTintSteps * tintEnd,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Hermite interpolation of [t], from 0 to 1: eases in and out, with no visible edge at either end.
double _smoothstep(double t) => t * t * (3 - 2 * t);

/// The buttons of a [BottomBar] with liquid glass buttons, evenly spaced and as wide as their
/// content. When they don't fit, the widest ones shrink first, to the same width: a label is
/// ellipsized, and icon buttons keep their width.
class const _GlassBarRow({required super.children}) extends MultiChildRenderObjectWidget {
  @override
  RenderObject createRenderObject(BuildContext context) => _RenderGlassBarRow();
}

class _GlassBarRowParentData() extends ContainerBoxParentData<RenderBox>;

class _RenderGlassBarRow()
    extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _GlassBarRowParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _GlassBarRowParentData> {
  static const double _minSpacing = 8.0;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _GlassBarRowParentData) {
      child.parentData = _GlassBarRowParentData();
    }
  }

  /// The widths of the children: their natural width, capped at the same width for the widest
  /// ones when they don't all fit in [available].
  List<double> _widths(double available, double height) {
    final natural = [
      for (var child = firstChild; child != null; child = childAfter(child))
        child.getMaxIntrinsicWidth(height),
    ];
    final spaceLeft = available - _minSpacing * (natural.length - 1);
    if (natural.fold(0.0, (a, b) => a + b) <= spaceLeft) return natural;

    // The cap such that the capped widths fill the space left.
    final sorted = [...natural]..sort();
    var remaining = spaceLeft;
    var cap = 0.0;
    for (var i = 0; i < sorted.length; i++) {
      cap = remaining / (sorted.length - i);
      if (sorted[i] > cap) break;
      remaining -= sorted[i];
    }
    return [for (final width in natural) math.min(width, math.max(cap, 0.0))];
  }

  @override
  void performLayout() {
    final widths = _widths(constraints.maxWidth, constraints.maxHeight);
    var i = 0;
    for (var child = firstChild; child != null; child = childAfter(child)) {
      child.layout(
        BoxConstraints(maxWidth: widths[i++], maxHeight: constraints.maxHeight),
        parentUsesSize: true,
      );
    }
    size = computeDryLayout(constraints);

    // Evenly spaced, with at least the minimum spacing between them.
    final childrenWidth = widths.fold(0.0, (a, b) => a + b);
    final gap = ((size.width - childrenWidth - _minSpacing * (childCount - 1)) / (childCount + 1))
        .clamp(0.0, double.infinity);
    var x = gap;
    for (var child = firstChild; child != null; child = childAfter(child)) {
      final parentData = child.parentData! as _GlassBarRowParentData;
      parentData.offset = Offset(x, (size.height - child.size.height) / 2);
      x += child.size.width + _minSpacing + gap;
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      constraints.constrain(Size(constraints.maxWidth, constraints.maxHeight));

  @override
  void paint(PaintingContext context, Offset offset) => defaultPaint(context, offset);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
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

/// A group of buttons of a [BottomBar] that belong together, like the board navigation buttons.
///
/// In a bar with [BottomBar.cupertinoGlass] on iOS, the group is one liquid glass capsule, like a
/// group of iOS toolbar items, and its [BottomBarButton]s are icons in it, without a capsule or a
/// label. Elsewhere, its [children] are laid out like the other buttons of the bar.
class const BottomBarGroup({required final List<Widget> children, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!_GlassBottomBarScope.isIn(context)) {
      return Row(mainAxisSize: MainAxisSize.min, children: children);
    }

    return _GlassBottomBarCapsule(
      onTap: () {},
      group: true,
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: _GlassBottomBarGroupScope(
        child: SizedBox(
          height: _kGlassCapsuleHeight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}

/// A custom button of a [BottomBar] with liquid glass buttons ([BottomBar.isGlass]): a glass
/// capsule around [child], for a button that is more than an icon and a label (e.g. the engine
/// button).
class const BottomBarGlassButton({
  required final VoidCallback? onTap,
  final VoidCallback? onLongPress,
  required final String semanticsLabel,
  required final Widget child,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      enabled: onTap != null,
      button: true,
      label: semanticsLabel,
      onLongPress: onLongPress,
      excludeSemantics: true,
      child: GestureDetector(
        onLongPress: onLongPress,
        child: _GlassBottomBarCapsule(onTap: onTap, child: child),
      ),
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

/// Marks the buttons of a [BottomBarGroup] in a [BottomBar] with [BottomBar.cupertinoGlass] on iOS.
class const _GlassBottomBarGroupScope({required super.child}) extends InheritedWidget {
  static bool isIn(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_GlassBottomBarGroupScope>() != null;

  @override
  bool updateShouldNotify(_GlassBottomBarGroupScope oldWidget) => false;
}

const double _kGlassCapsuleHeight = 40.0;

/// Width of an icon button in a liquid glass [BottomBar]: a circle on its own, and a slot of the
/// same width in a [BottomBarGroup].
const double _kGlassIconButtonWidth = _kGlassCapsuleHeight;

/// A liquid glass capsule button of a [BottomBar] with [BottomBar.cupertinoGlass], as wide as its
/// content.
class const _GlassBottomBarCapsule({
  required final VoidCallback? onTap,
  required final Widget child,
  final bool prominent = false,

  /// Whether the capsule pulses with a wash of the theme color, to draw attention to it.
  final bool blink = false,

  /// Whether the capsule holds the buttons of a [BottomBarGroup], which handle the taps.
  final bool group = false,
  final EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16.0),
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final colorScheme = ColorScheme.of(context);
    final foregroundColor = prominent ? colorScheme.primary : colorScheme.onSurface;
    final glassSettings = tintedGlassSettings(context);
    // A wash that shows on the light glass as well as on the dark one.
    final washAlpha = Theme.of(context).brightness == Brightness.light ? 0.3 : 0.15;

    Widget buildButton(double wash) => GlassButton.custom(
      onTap: onTap ?? () {},
      enabled: enabled,
      // Tinted for busy content, like boards. A prominent button gets a light wash of the theme
      // color, with a label in that color, like an iOS tinted button.
      settings: wash > 0
          ? glassSettings.copyWith(
              glassColor: Color.alphaBlend(
                colorScheme.primary.withValues(alpha: washAlpha * wash),
                glassSettings.glassColor,
              ),
            )
          : glassSettings,
      shape: const LiquidRoundedRectangle(borderRadius: 100),
      // The bar has no glass layer to share.
      useOwnLayer: true,
      width: double.infinity,
      height: _kGlassCapsuleHeight,
      // The buttons of a group have their own semantics and focus.
      excludeFromSemantics: group,
      canRequestFocus: !group,
      // A wide group stretches less, like an iOS toolbar group.
      stretch: group ? 0.15 : 0.5,
      child: Padding(
        padding: padding,
        child: IconTheme.merge(
          data: IconThemeData(color: foregroundColor, size: 20.0),
          child: DefaultTextStyle.merge(
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: foregroundColor),
            child: child,
          ),
        ),
      ),
    );

    // As wide as its content, within the width the bar gives it.
    return IntrinsicWidth(
      child: Opacity(
        opacity: enabled ? 1.0 : 0.4,
        child: blink ? _Blink(builder: buildButton) : buildButton(prominent ? 1.0 : 0.0),
      ),
    );
  }
}

/// Builds a liquid glass button with a wash of the theme color that comes and goes, from 0 to 1.
class const _Blink({required final Widget Function(double wash) builder}) extends StatefulWidget {
  @override
  State<_Blink> createState() => _BlinkState();
}

class _BlinkState() extends State<_Blink> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 2000),
    vsync: this,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) => widget.builder(_controller.value),
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
      final content = Row(
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
      );
      // An icon alone is a circle.
      final iconOnly = !showLabel && badgeLabel == null;
      // In a group, a button is an icon without its label, like an iOS toolbar group item, in a
      // slot as wide as the icon alone.
      final groupSlot = Padding(
        padding: EdgeInsets.symmetric(
          horizontal: badgeLabel == null ? (_kGlassIconButtonWidth - 20.0) / 2 : 12.0,
        ),
        child: Center(widthFactor: 1.0, child: badge),
      );

      return Semantics(
        container: true,
        enabled: enabled,
        button: true,
        label: label,
        excludeSemantics: true,
        child: _GlassBottomBarGroupScope.isIn(context)
            // The group's capsule is the button's background.
            ? GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
                child: Opacity(
                  opacity: enabled ? 1.0 : 0.4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: blink
                        ? _AnimatedInvertBackground(
                            color: primary.withValues(alpha: 0.2),
                            child: groupSlot,
                          )
                        : groupSlot,
                  ),
                ),
              )
            : _GlassBottomBarCapsule(
                onTap: onTap,
                prominent: prominent,
                blink: blink,
                padding: iconOnly
                    ? const EdgeInsets.symmetric(horizontal: (_kGlassIconButtonWidth - 20.0) / 2)
                    : const EdgeInsets.symmetric(horizontal: 16.0),
                child: content,
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

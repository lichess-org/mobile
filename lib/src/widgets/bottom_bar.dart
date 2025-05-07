import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/constants.dart';

/// A bottom bar that can be used in a [Scaffold.bottomNavigationBar].
///
/// The height of the bar is always [kBottomBarHeight] and the font size scale factor is
/// clamped to 1.4.
class BottomBar extends StatelessWidget {
  const BottomBar({
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
    this.expandChildren = true,
    this.cupertinoTransparent = false,
  });

  const BottomBar.empty({this.cupertinoTransparent = false})
    : children = const [],
      expandChildren = true,
      mainAxisAlignment = MainAxisAlignment.spaceAround;

  /// Children to display in the bottom bar's [Row]. Typically instances of [BottomBarButton].
  final List<Widget> children;

  /// Alignment of the bottom bar's internal row. Defaults to [MainAxisAlignment.spaceAround].
  final MainAxisAlignment mainAxisAlignment;

  /// Whether to expand the children to fill the available space. Defaults to true.
  final bool expandChildren;

  /// Whether to use a transparent background on iOS. Defaults to false.
  final bool cupertinoTransparent;

  @override
  Widget build(BuildContext context) {
    Widget bar = BottomAppBar(
      color:
          Theme.of(context).platform == TargetPlatform.iOS && cupertinoTransparent
              ? (BottomAppBarTheme.of(context).color ?? ColorScheme.of(context).surface).withValues(
                alpha: 0.9,
              )
              : null,
      height: kBottomBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children:
            expandChildren ? children.map((child) => Expanded(child: child)).toList() : children,
      ),
    );

    if (Theme.of(context).platform == TargetPlatform.iOS && cupertinoTransparent) {
      bar = ClipRect(
        child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), child: bar),
      );
    }

    return MediaQuery.withClampedTextScaling(maxScaleFactor: 1.4, child: bar);
  }
}

/// A bottom bar button.
///
/// Typically used in a [BottomBar].
class BottomBarButton extends StatelessWidget {
  const BottomBarButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badgeLabel,
    this.highlighted = false,
    this.showLabel = false,
    this.showTooltip = true,
    this.blink = false,
    this.tooltip,
    super.key,
  });

  final IconData icon;
  final String label;
  final String? badgeLabel;
  final VoidCallback? onTap;

  final bool highlighted;
  final bool showLabel;
  final bool showTooltip;
  final bool blink;

  /// In case we want to override the tooltip message. If null, the [label] will
  /// be used.
  final String? tooltip;

  bool get enabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    final primary = ColorScheme.of(context).primary;

    final labelFontSize = TextTheme.of(context).bodySmall?.fontSize;

    final child = Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Badge(
            backgroundColor: ColorScheme.of(context).secondary,
            textStyle: TextStyle(
              color: ColorScheme.of(context).onSecondary,
              fontWeight: FontWeight.bold,
            ),
            isLabelVisible: badgeLabel != null,
            label: (badgeLabel != null) ? Text(badgeLabel!) : null,
            child: Icon(icon, color: highlighted ? primary : null),
          ),
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
          child:
              blink
                  ? _AnimatedInvertBackground(color: primary.withValues(alpha: 0.2), child: child)
                  : child,
        ),
      ),
    );
  }
}

class _AnimatedInvertBackground extends StatefulWidget {
  const _AnimatedInvertBackground({required this.child, required this.color});

  final Widget child;
  final Color color;

  @override
  _InvertBackgroundState createState() => _InvertBackgroundState();
}

class _InvertBackgroundState extends State<_AnimatedInvertBackground>
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

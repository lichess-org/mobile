import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';

/// A bottom bar button.
///
/// Typically used in a [PlatformBottomBar].
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

    final labelFontSize =
        Theme.of(context).platform == TargetPlatform.iOS
            ? 11.0
            : TextTheme.of(context).bodySmall?.fontSize;

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

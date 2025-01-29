import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

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
    this.invertBackground = false,
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
  final bool invertBackground;

  /// In case we want to override the tooltip message. If null, the [label] will
  /// be used.
  final String? tooltip;

  bool get enabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    final labelFontSize =
        Theme.of(context).platform == TargetPlatform.iOS
            ? 11.0
            : Theme.of(context).textTheme.bodySmall?.fontSize;

    final child = Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Badge(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontWeight: FontWeight.bold,
            ),
            isLabelVisible: badgeLabel != null,
            label: (badgeLabel != null) ? Text(badgeLabel!) : null,
            child:
                blink
                    ? _BlinkIcon(
                      icon: icon,
                      color:
                          highlighted ? primary : Theme.of(context).iconTheme.color ?? Colors.black,
                    )
                    : Icon(icon, color: highlighted ? primary : null),
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
        child: AdaptiveInkWell(
          borderRadius: BorderRadius.zero,
          onTap: onTap,
          child:
              invertBackground
                  ? _InvertBackground(color: primary.withValues(alpha: 0.2), child: child)
                  : child,
        ),
      ),
    );
  }
}

class _BlinkIcon extends StatefulWidget {
  const _BlinkIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  _BlinkIconState createState() => _BlinkIconState();
}

class _BlinkIconState extends State<_BlinkIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    _colorAnimation = ColorTween(begin: widget.color, end: null).animate(_controller)
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
      builder: (_, __) => Icon(widget.icon, color: _colorAnimation.value ?? Colors.transparent),
    );
  }
}

class _InvertBackground extends StatefulWidget {
  const _InvertBackground({required this.child, required this.color});

  final Widget child;
  final Color color;

  @override
  _InvertBackgroundState createState() => _InvertBackgroundState();
}

class _InvertBackgroundState extends State<_InvertBackground> with SingleTickerProviderStateMixin {
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
      builder: (_, __) => Container(color: _colorAnimation.value, child: widget.child),
    );
  }
}

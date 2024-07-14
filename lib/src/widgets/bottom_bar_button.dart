import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

/// A bottom bar button.
class BottomBarButton extends StatelessWidget {
  const BottomBarButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.chip,
    this.highlighted = false,
    this.showLabel = false,
    this.showTooltip = true,
    this.blink = false,
    this.tooltip,
    super.key,
  });

  final IconData icon;
  final String label;
  final Widget? chip;
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
    final primary = Theme.of(context).colorScheme.primary;

    final chipColor = Theme.of(context).colorScheme.secondary;

    final labelFontSize = Theme.of(context).platform == TargetPlatform.iOS
        ? 11.0
        : Theme.of(context).textTheme.bodySmall?.fontSize;

    return Semantics(
      container: true,
      enabled: enabled,
      button: true,
      label: label,
      excludeSemantics: true,
      child: Tooltip(
        excludeFromSemantics: true,
        message: label,
        triggerMode: showTooltip
            ? TooltipTriggerMode.longPress
            : TooltipTriggerMode.manual,
        child: AdaptiveInkWell(
          borderRadius: BorderRadius.zero,
          onTap: onTap,
          child: Opacity(
            opacity: enabled ? 1.0 : 0.4,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (blink)
                      _BlinkIcon(
                        icon: icon,
                        color: highlighted
                            ? primary
                            : Theme.of(context).iconTheme.color ?? Colors.black,
                      )
                    else
                      Icon(icon, color: highlighted ? primary : null),
                    if (showLabel)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: labelFontSize,
                            color: highlighted ? primary : null,
                          ),
                        ),
                      ),
                  ],
                ),
                if (chip != null)
                  Positioned(
                    top: 2.0,
                    right: 2.0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.brightness_1,
                          size: 20.0,
                          color: chipColor,
                        ),
                        FittedBox(
                          fit: BoxFit.contain,
                          child: DefaultTextStyle.merge(
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                            child: chip!,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BlinkIcon extends StatefulWidget {
  const _BlinkIcon({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  _BlinkIconState createState() => _BlinkIconState();
}

class _BlinkIconState extends State<_BlinkIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _colorAnimation =
        ColorTween(begin: widget.color, end: null).animate(_controller)
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
      builder: (context, child) {
        return Icon(
          widget.icon,
          color: _colorAnimation.value ?? Colors.transparent,
        );
      },
    );
  }
}

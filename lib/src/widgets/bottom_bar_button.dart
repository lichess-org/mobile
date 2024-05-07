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

  /// In case we want to override the tooltip message. If null, the [label] will
  /// be used.
  final String? tooltip;

  bool get enabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    final chipColor = primary;

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
                    Icon(
                      icon,
                      color: highlighted ? primary : null,
                    ),
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
                              color: Theme.of(context).colorScheme.onPrimary,
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

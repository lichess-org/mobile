import 'package:flutter/cupertino.dart';
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
    final materialThemeData = Theme.of(context);
    final platform = materialThemeData.platform;
    final cupertinoThemeData = CupertinoTheme.of(context);

    final primary = platform == TargetPlatform.iOS
        ? cupertinoThemeData.primaryColor
        : materialThemeData.colorScheme.primary;

    final chipColor = platform == TargetPlatform.iOS
        ? CupertinoColors.activeBlue.resolveFrom(context)
        : materialThemeData.colorScheme.primary;

    final labelFontSize = materialThemeData.platform == TargetPlatform.iOS
        ? 11.0
        : materialThemeData.textTheme.bodySmall?.fontSize;

    final button = IconTheme.merge(
      data: IconThemeData(
        color: platform == TargetPlatform.iOS
            ? cupertinoThemeData.textTheme.textStyle.color
            : materialThemeData.textTheme.bodyMedium?.color,
      ),
      child: Semantics(
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
                                color: platform == TargetPlatform.iOS
                                    ? Colors.white
                                    : materialThemeData.colorScheme.onPrimary,
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
      ),
    );

    switch (platform) {
      case TargetPlatform.android:
        return Theme(
          data: materialThemeData,
          child: button,
        );
      case TargetPlatform.iOS:
        return CupertinoTheme(
          data: cupertinoThemeData.copyWith(
            primaryColor: cupertinoThemeData.textTheme.textStyle.color,
          ),
          child: button,
        );
      default:
        assert(false, 'Unexpected platform $Theme.of(context).platform');
        return const SizedBox.shrink();
    }
  }
}

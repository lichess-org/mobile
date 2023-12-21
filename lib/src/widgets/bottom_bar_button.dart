import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
    super.key,
  });

  final IconData icon;
  final String label;
  final Widget? chip;
  final VoidCallback? onTap;

  final bool highlighted;
  final bool showLabel;
  final bool showTooltip;

  bool get enabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    final materialThemeData = Theme.of(context);
    final cupertinoThemeData = CupertinoTheme.of(context);

    final primary = defaultTargetPlatform == TargetPlatform.iOS
        ? cupertinoThemeData.primaryColor
        : materialThemeData.colorScheme.primary;

    final chipColor = defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoColors.activeBlue.resolveFrom(context)
        : materialThemeData.colorScheme.primary;

    final labelFontSize = defaultTargetPlatform == TargetPlatform.iOS
        ? 11.0
        : materialThemeData.textTheme.bodySmall?.fontSize;

    final button = Semantics(
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
                              color: defaultTargetPlatform == TargetPlatform.iOS
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
    );

    switch (defaultTargetPlatform) {
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
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}

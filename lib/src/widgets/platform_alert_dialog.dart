import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoColors;
import 'package:lichess_mobile/src/widgets/glass_modal.dart';
import 'package:lichess_mobile/src/widgets/platform.dart' show useLiquidGlass;
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassButton, LiquidGlassSettings, LiquidRoundedSuperellipse;
import 'package:material_ui/material_ui.dart';

const _kGlassDialogButtonHeight = 44.0;

/// An alert dialog: a Material [AlertDialog] on Android, a liquid glass dialog on iOS.
///
/// To be shown with [showAdaptiveDialog], with [PlatformDialogAction]s as [actions].
///
/// The iOS dialog is laid out like the package's `GlassDialog`, which can't be used directly: it
/// takes a text title and message only, and at most 3 actions.
class const PlatformAlertDialog({
  super.key,

  /// The (optional) title of the dialog, displayed in a large font at the top of the dialog.
  final Widget? title,

  /// The (optional) content of the dialog, displayed in the center of the dialog.
  final Widget? content,

  /// The (optional) set of actions, typically [PlatformDialogAction]s, displayed at the bottom of
  /// the dialog.
  final List<Widget>? actions,

  /// Passed to [AlertDialog.contentPadding] on Android. The iOS content has no padding of its own.
  final EdgeInsetsGeometry? contentPadding,

  /// Passed to [AlertDialog.scrollable] on Android. The iOS content always scrolls when too tall.
  final bool scrollable = false,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform != TargetPlatform.iOS) {
      return AlertDialog(
        title: title,
        content: content,
        actions: actions,
        contentPadding: contentPadding,
        scrollable: scrollable,
      );
    }

    final labelColor = CupertinoColors.label.resolveFrom(context);
    final iosActions = actions ?? const <Widget>[];
    return GlassDialogFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null || content != null)
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 8.0,
                  children: [
                    if (title != null)
                      DefaultTextStyle(
                        style: TextStyle(
                          color: labelColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        child: title!,
                      ),
                    if (content != null)
                      DefaultTextStyle(
                        style: TextStyle(color: labelColor, fontSize: 15, height: 1.3),
                        textAlign: TextAlign.center,
                        child: content!,
                      ),
                  ],
                ),
              ),
            ),
          if (iosActions.isNotEmpty) ...[
            if (title != null || content != null) const SizedBox(height: 20),
            // Side by side when there are two actions, stacked otherwise, like on iOS.
            if (iosActions.length == 2)
              Row(
                spacing: 8.0,
                children: [for (final action in iosActions) Expanded(child: action)],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8.0,
                children: iosActions,
              ),
          ],
        ],
      ),
    );
  }
}

/// An action of a [PlatformAlertDialog]: a [TextButton] on Android, a liquid glass capsule button
/// on iOS (a flat one before iOS 26).
class const PlatformDialogAction({
  super.key,

  /// Callback invoked when the action is pressed.
  required final VoidCallback? onPressed,

  /// The label of the action, typically a [Text].
  required final Widget child,

  /// Whether this is the default action, displayed in bold on iOS. No effect on Android.
  final bool cupertinoIsDefaultAction = false,

  /// Whether this action is destructive, displayed in red on iOS. No effect on Android.
  final bool cupertinoIsDestructiveAction = false,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform != TargetPlatform.iOS) {
      return TextButton(onPressed: onPressed, child: child);
    }

    final color = cupertinoIsDestructiveAction
        ? CupertinoColors.destructiveRed
        : CupertinoColors.label.resolveFrom(context);
    final label = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: DefaultTextStyle(
        style: TextStyle(
          color: onPressed != null ? color : color.withValues(alpha: 0.4),
          fontSize: 17,
          fontWeight: cupertinoIsDefaultAction ? FontWeight.w600 : FontWeight.w500,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        child: child,
      ),
    );

    if (!useLiquidGlass(context)) {
      // The same capsule on the control fill.
      return Material(
        color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            height: _kGlassDialogButtonHeight,
            child: Center(widthFactor: 1.0, child: label),
          ),
        ),
      );
    }

    return GlassButton.custom(
      onTap: onPressed ?? () {},
      enabled: onPressed != null,
      height: _kGlassDialogButtonHeight,
      shape: const LiquidRoundedSuperellipse(borderRadius: _kGlassDialogButtonHeight / 2),
      // Over the dialog card, which has its own glass layer.
      useOwnLayer: true,
      settings: const LiquidGlassSettings(),
      child: label,
    );
  }
}

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/tab_navigation.dart' show isTabBarHiddenAt;
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/glass_modal.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' show GlassDefaults;
import 'package:material_ui/material_ui.dart';

/// A action bottom sheet that adapts to the platform (Android/iOS).
///
/// [actions] The Actions list that will appear on the ActionSheet. (required)
///
/// [title] The optional title widget that show above the actions.
///
/// The optional [isDismissible] can be passed to set barrierDismissible of showCupertinoModalPopup
/// and isDismissible of showModalBottomSheet (Default true as for both implementations)
Future<T?> showAdaptiveActionSheet<T>({
  required BuildContext context,
  Widget? title,
  required List<BottomSheetAction> actions,
  bool isDismissible = true,
}) {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    return showCupertinoActionSheet(
      context: context,
      title: title,
      actions: actions,
      isDismissible: isDismissible,
    );
  } else {
    return showMaterialActionSheet(
      context: context,
      title: title,
      actions: actions,
      isDismissible: isDismissible,
    );
  }
}

Future<T?> showConfirmDialog<T>(
  BuildContext context, {
  required Widget title,
  required VoidCallback onConfirm,

  /// Only for iOS
  bool isDestructiveAction = false,
}) {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    return showCupertinoActionSheet(
      context: context,
      actions: [
        BottomSheetAction(
          makeLabel: (_) => title,
          isDestructiveAction: isDestructiveAction,
          onPressed: onConfirm,
        ),
      ],
    );
  } else {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title,
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(textStyle: TextTheme.of(context).labelLarge),
              child: Text(context.l10n.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(textStyle: TextTheme.of(context).labelLarge),
              child: Text(context.l10n.mobileOkButton),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }
}

/// Shows an iOS 26 liquid glass action sheet.
///
/// Laid out like the package's `showGlassActionSheet` (a card of actions above a separate cancel
/// button), which can't be used directly: it takes text labels only, and pops the sheet after an
/// action's callback, which would pop a route pushed by that callback.
Future<T?> showCupertinoActionSheet<T>({
  required BuildContext context,
  Widget? title,
  required List<BottomSheetAction> actions,
  bool isDismissible = true,
}) {
  return showCupertinoModalPopup(
    context: context,
    // The root navigator is only needed to cover the tab bar: a screen hiding it presents its
    // action sheets on its own navigator, so that the screens they push stay in its stack.
    useRootNavigator: !isTabBarHiddenAt(context),
    barrierDismissible: isDismissible,
    barrierColor: GlassDefaults.barrierColor,
    builder: (BuildContext context) {
      final separatorColor = CupertinoColors.separator.resolveFrom(context);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: kMaterialPopupMenuMaxWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: GlassModalCard(
                    tinted: true,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (title != null)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                                child: title,
                              ),
                            ),
                          for (final (index, action) in actions.indexed) ...[
                            if (index > 0 || title != null)
                              Container(height: 0.5, color: separatorColor),
                            // Builder is used to retrieve the context immediately surrounding the
                            // button. This is necessary to get the correct context for the iPad
                            // share dialog which needs the position of the action to display the
                            // share dialog.
                            Builder(
                              builder: (context) {
                                return _GlassActionSheetButton(
                                  onPressed: () {
                                    if (action.dismissOnPress) {
                                      Navigator.of(context).pop();
                                    }
                                    action.onPressed();
                                  },
                                  isDestructiveAction: action.isDestructiveAction,
                                  isDefaultAction: action.isDefaultAction,
                                  child: action.makeLabel(context),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GlassModalCard(
                  tinted: true,
                  child: _GlassActionSheetButton(
                    isDefaultAction: true,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(context.l10n.cancel),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// A full width action sheet row, highlighted while pressed.
class const _GlassActionSheetButton({
  required final VoidCallback onPressed,
  required final Widget child,
  final bool isDestructiveAction = false,
  final bool isDefaultAction = false,
}) extends StatefulWidget {
  @override
  State<_GlassActionSheetButton> createState() => _GlassActionSheetButtonState();
}

class _GlassActionSheetButtonState() extends State<_GlassActionSheetButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed != value) setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: _isPressed ? Duration.zero : const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 56),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: _isPressed ? labelColor.withValues(alpha: 0.06) : labelColor.withValues(alpha: 0),
          child: DefaultTextStyle(
            style: TextStyle(
              color: widget.isDestructiveAction ? CupertinoColors.destructiveRed : labelColor,
              fontSize: 17,
              fontWeight: widget.isDefaultAction ? FontWeight.w600 : FontWeight.w400,
              letterSpacing: -0.4,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            child: IconTheme.merge(
              data: IconThemeData(
                color: widget.isDestructiveAction ? CupertinoColors.destructiveRed : labelColor,
                size: 20,
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

Future<T?> showMaterialActionSheet<T>({
  required BuildContext context,
  Widget? title,
  required List<BottomSheetAction> actions,
  bool isDismissible = true,
}) {
  final actionTextStyle = TextTheme.of(context).titleMedium ?? const TextStyle(fontSize: 18);

  final screenWidth = MediaQuery.widthOf(context);
  return showDialog<T>(
    context: context,
    // See showCupertinoActionSheet.
    useRootNavigator: !isTabBarHiddenAt(context),
    barrierDismissible: isDismissible,
    builder: (BuildContext context) {
      return Dialog(
        child: SizedBox(
          width: min(screenWidth, kMaterialPopupMenuMaxWidth),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (title != null) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(child: title),
                  ),
                ],
                ...actions.mapIndexed<Widget>((index, action) {
                  return InkWell(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(index == 0 ? 28 : 0),
                      bottom: Radius.circular(index == actions.length - 1 ? 28 : 0),
                    ),
                    onTap: () {
                      if (action.dismissOnPress) {
                        Navigator.of(context).pop();
                      }
                      action.onPressed();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          if (action.leading != null) ...[
                            action.leading!,
                            const SizedBox(width: 15),
                          ],
                          Expanded(
                            child: DefaultTextStyle(
                              style: actionTextStyle,
                              textAlign: action.leading != null
                                  ? TextAlign.start
                                  : TextAlign.center,
                              child: action.makeLabel(context),
                            ),
                          ),
                          if (action.trailing != null) ...[
                            const SizedBox(width: 10),
                            action.trailing!,
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// The Actions model that will use on the ActionSheet.
class BottomSheetAction({
  /// A function that returns the label widget. (required)
  ///
  /// Typically a [Text] widget.
  ///
  /// This should not wrap. To enforce the single line limit, use
  /// [Text.maxLines].
  required final Widget Function(BuildContext context) makeLabel,

  /// The callback that is called when the action item is tapped. (required)
  required final VoidCallback onPressed,

  /// Whether the modal should be dismissed when an action is pressed.
  ///
  /// Default to true.
  final bool dismissOnPress = true,

  /// A widget to display after the label.
  ///
  /// Typically an [Icon] widget. (Android only).
  final Widget? trailing,

  /// A widget to display before the label.
  ///
  /// Typically an [Icon] or a [CircleAvatar] widget. (Android only).
  final Widget? leading,

  /// Whether the action is destructive. (iOS only).
  final bool isDestructiveAction = false,

  /// Whether the action is the default action. (iOS only).
  final bool isDefaultAction = false,
});

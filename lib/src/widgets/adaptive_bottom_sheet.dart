import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/widgets/list.dart';

/// A modal bottom sheet that adapts to the platform (Android/iOS).
Future<T?> showAdaptiveBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isDismissible = true,
  bool useRootNavigator = true,
  bool useSafeArea = true,
  bool isScrollControlled = false,
  bool? showDragHandle,
  BoxConstraints? constraints,
}) async {
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
    showDragHandle: showDragHandle,
    isScrollControlled: isScrollControlled,
    useRootNavigator: useRootNavigator,
    useSafeArea: useSafeArea,
    shape: Theme.of(context).platform == TargetPlatform.iOS
        ? const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.0),
            ),
          )
        : null,
    constraints: constraints,
    backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoDynamicColor.resolve(
            CupertinoColors.tertiarySystemGroupedBackground,
            context,
          )
        : null,
    elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0 : null,
    builder: builder,
  );
}

class BottomSheetContextMenuAction extends StatelessWidget {
  const BottomSheetContextMenuAction({
    required this.child,
    this.icon,
    this.onPressed,
    this.closeOnPressed = true,
  });

  final IconData? icon;
  final VoidCallback? onPressed;
  final Widget child;
  final bool closeOnPressed;

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      leading: Icon(icon),
      title: child,
      onTap: () {
        if (closeOnPressed) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        onPressed?.call();
      },
    );
  }
}

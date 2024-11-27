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

/// A modal bottom sheet container that adapts to the content size.
///
/// This is typically used with [showAdaptiveBottomSheet] to display a
/// context menu.
///
/// This is meant for content that mostly fits on the screen, not for long lists.
class BottomSheetScrollableContainer extends StatelessWidget {
  const BottomSheetScrollableContainer({
    required this.children,
    this.padding = const EdgeInsets.only(bottom: 16.0),
    this.scrollController,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        controller: scrollController,
        padding: padding,
        child: ListBody(
          children: children,
        ),
      ),
    );
  }
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
      cupertinoBackgroundColor:
          CupertinoColors.tertiarySystemGroupedBackground.resolveFrom(context),
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

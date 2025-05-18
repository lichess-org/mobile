import 'package:flutter/material.dart';

/// A modal bottom sheet container that adapts to the content size.
///
/// This is typically used with [showModalBottomSheet] to display a
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
        child: ListBody(children: children),
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
    return ListTile(
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

import 'package:material_ui/material_ui.dart';

/// A modal bottom sheet container that adapts to the content size.
///
/// This is typically used with [showModalBottomSheet] to display a
/// context menu.
///
/// This is meant for content that mostly fits on the screen, not for long lists.
class const BottomSheetScrollableContainer({
  required final List<Widget> children,
  final EdgeInsetsGeometry? padding = const EdgeInsets.symmetric(vertical: 16.0),
  final ScrollController? scrollController,
}) extends StatelessWidget {
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

class const BottomSheetContextMenuAction({
  required final Widget child,
  final IconData? icon,
  final VoidCallback? onPressed,
  final bool closeOnPressed = true,
}) extends StatelessWidget {
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

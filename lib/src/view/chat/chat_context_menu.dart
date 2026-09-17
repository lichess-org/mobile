import 'package:flutter/services.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:material_ui/material_ui.dart';

class const ChatBubbleContextMenu({
  required final Widget child,

  /// The message in the chat bubble, used for copying to clipboard.
  required final String message,

  /// List of actions to display in the context menu. Typically [BottomSheetContextMenuAction].
  final List<Widget> actions = const [],
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        isDismissible: true,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (context) => BottomSheetScrollableContainer(
          children: [
            BottomSheetContextMenuAction(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: message));
                if (!context.mounted) return;
                showSnackBar(context, 'Message copied.');
              },
              icon: Icons.copy_all_outlined,
              child: Text(context.l10n.copyToClipboard),
            ),
            ...actions,
          ],
        ),
      ),
      child: child,
    );
  }
}

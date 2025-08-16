import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';

class ChatBubbleContextMenu extends StatelessWidget {
  const ChatBubbleContextMenu({
    required this.child,
    required this.message,
    this.actions = const [],
    super.key,
  });

  final Widget child;

  /// The message in the chat bubble, used for copying to clipboard.
  final String message;

  /// List of actions to display in the context menu. Typically [BottomSheetContextMenuAction].
  final List<Widget> actions;

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
                showSnackBar(context, 'Successfully copied to clipboard');
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

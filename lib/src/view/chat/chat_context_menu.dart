import 'package:flutter/services.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:material_ui/material_ui.dart';

/// A chat bubble that opens a context menu where it is long pressed: copy the message, and
/// [actions].
class const ChatBubbleContextMenu({
  required final Widget child,

  /// The message in the chat bubble, used for copying to clipboard.
  required final String message,

  /// More actions of the context menu, after the copy action.
  final List<ContextMenuAction> actions = const [],
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion(
      actions: [
        ContextMenuAction(
          icon: Icons.copy_all_outlined,
          label: context.l10n.copyToClipboard,
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: message));
            if (!context.mounted) return;
            showSnackBar(context, 'Message copied.');
          },
        ),
        ...actions,
      ],
      child: child,
    );
  }
}

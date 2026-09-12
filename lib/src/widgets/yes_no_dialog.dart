import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:material_ui/material_ui.dart';

class const YesNoDialog({
  super.key,
  final Widget? title,
  final Widget? content,
  required final VoidCallback onYes,
  required final VoidCallback onNo,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: title,
      content: content,
      actions: [
        PlatformDialogAction(onPressed: onNo, child: Text(context.l10n.no)),
        PlatformDialogAction(onPressed: onYes, child: Text(context.l10n.yes)),
      ],
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

/// Shares the given [uri], [files], or [text].
///
/// Using this function is recommended over calling [SharePlus.instance.share] directly
/// in order to make it work on iPads.
Future<ShareResult> launchShareDialog(
  BuildContext context,
  ShareParams params,
) {
  final box = context.findRenderObject() as RenderBox?;
  final origin = box != null ? box.localToGlobal(Offset.zero) & box.size : null;

  return SharePlus.instance.share(
    ShareParams(
      uri: params.uri,
      files: params.files,
      text: params.text,
      subject: params.subject,
      fileNameOverrides: params.fileNameOverrides,
      sharePositionOrigin: origin,
    ),
  );
}

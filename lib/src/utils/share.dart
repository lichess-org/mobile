import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

/// Shares the given [uri], [files], or [text].
///
/// Using this function is recommended over calling [Share.share] directly
/// in order to make it work on iPads.
Future<void> launchShareDialog(
  BuildContext context, {

  /// The uri to share.
  Uri? uri,

  /// The files to share.
  List<XFile>? files,

  /// The subject.
  String? subject,

  /// The text to share.
  String? text,
}) {
  assert(uri != null || files != null || text != null);
  final box = context.findRenderObject() as RenderBox?;
  final origin = box != null ? box.localToGlobal(Offset.zero) & box.size : null;

  if (uri != null) {
    return Share.shareUri(uri);
  } else if (files != null) {
    return Share.shareXFiles(files, subject: subject, text: text, sharePositionOrigin: origin);
  } else if (text != null) {
    return Share.share(text, subject: subject, sharePositionOrigin: origin);
  }

  throw ArgumentError('uri, files, or text must be provided');
}

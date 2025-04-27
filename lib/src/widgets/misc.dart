import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:url_launcher/url_launcher.dart';

/// A widget that displays a title in the app bar with auto-sizing text.
class AppBarTitleText extends StatelessWidget {
  const AppBarTitleText(
    this.text, {
    super.key,
    this.minFontSize,
    this.maxFontSize,
    this.maxLines = 1,
  }) : assert(maxLines > 0 && maxLines <= 2);

  final String text;
  final int maxLines;
  final double? minFontSize;
  final double? maxFontSize;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      maxLines: maxLines,
      style: maxLines > 1 ? const TextStyle(height: 1) : null,
      minFontSize: minFontSize ?? 14.0,
      maxFontSize:
          maxFontSize ??
          (maxLines > 1 ? 18 : AppBarTheme.of(context).titleTextStyle?.fontSize ?? 20.0),
      overflow: TextOverflow.ellipsis,
    );
  }
}

class LichessMessage extends StatefulWidget {
  const LichessMessage({super.key, this.style, this.textAlign = TextAlign.start});

  final TextStyle? style;
  final TextAlign textAlign;

  @override
  State<LichessMessage> createState() => _LichessMessageState();
}

class _LichessMessageState extends State<LichessMessage> {
  late TapGestureRecognizer _recognizer;

  @override
  void initState() {
    super.initState();
    _recognizer = TapGestureRecognizer()..onTap = _handleTap;
  }

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  void _handleTap() {
    launchUrl(Uri.parse('https://lichess.org/features'));
  }

  @override
  Widget build(BuildContext context) {
    final trans = context.l10n.xIsAFreeYLibreOpenSourceChessServer('Lichess', context.l10n.really);
    final regexp = RegExp(r'''^([^(]*\()([^)]*)(\).*)$''');
    final match = regexp.firstMatch(trans);
    final List<TextSpan> spans = [];
    if (match != null) {
      for (var i = 1; i <= match.groupCount; i++) {
        spans.add(
          TextSpan(
            text: match[i],
            style: i == 2 ? TextStyle(color: ColorScheme.of(context).primary) : null,
            recognizer: i == 2 ? _recognizer : null,
          ),
        );
      }
    } else {
      spans.add(TextSpan(text: trans));
    }

    return Text.rich(TextSpan(style: widget.style, children: spans), textAlign: widget.textAlign);
  }
}

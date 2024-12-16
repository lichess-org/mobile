import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:url_launcher/url_launcher.dart';

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
            style: i == 2 ? TextStyle(color: Theme.of(context).colorScheme.primary) : null,
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

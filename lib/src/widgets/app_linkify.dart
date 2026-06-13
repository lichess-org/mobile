import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/app_links_service.dart';
import 'package:lichess_mobile/src/widgets/app_link_parser.dart';

class AppLinkify extends StatelessWidget {
  const AppLinkify({
    super.key,
    required this.text,
    required this.linkService,
    this.style,
    this.linkStyle,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  });

  final String text;
  final AppLinksService linkService;

  final TextStyle? style;
  final TextStyle? linkStyle;
  final int? maxLines;
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    final chunks = AppLinkParser.parse(text);

    return RichText(
      maxLines: maxLines,
      overflow: overflow,
      text: TextSpan(
        style: style,
        children: chunks.map((chunk) {
          if (chunk is TextChunk) {
            return TextSpan(text: chunk.text);
          }

          final link = chunk as LinkChunk;

          return TextSpan(
            text: link.text,
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () => linkService.onLinkTap(context, link.link),
          );
        }).toList(),
      ),
    );
  }
}

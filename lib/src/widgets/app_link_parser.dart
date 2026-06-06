import 'package:lichess_mobile/src/widgets/app_link.dart';

sealed class AppLinkSpan {
  const AppLinkSpan();
}

final class TextChunk extends AppLinkSpan {
  const TextChunk(this.text);

  final String text;
}

final class LinkChunk extends AppLinkSpan {
  const LinkChunk({required this.text, required this.link});

  final String text;
  final AppLink link;
}

class AppLinkParser {
  const AppLinkParser._();

  static final _pattern = RegExp(
    r'((?:https?://)(?:[^\s<>()]+|\([^\s<>()]*\))+(?:[^\s`!()\[\]{};:".,<>?«»“”‘’]))'
    '|(@[A-Za-z0-9_-]+)',
    caseSensitive: false,
  );

  static List<AppLinkSpan> parse(String text) {
    final result = <AppLinkSpan>[];

    int lastEnd = 0;

    for (final match in _pattern.allMatches(text)) {
      if (match.start > lastEnd) {
        result.add(TextChunk(text.substring(lastEnd, match.start)));
      }

      final token = match.group(0)!;

      if (token.startsWith('@')) {
        result.add(LinkChunk(text: token, link: MentionLink(token.substring(1))));
      } else {
        result.add(LinkChunk(text: token, link: UrlLink(Uri.parse(token))));
      }

      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      result.add(TextChunk(text.substring(lastEnd)));
    }

    return result;
  }
}

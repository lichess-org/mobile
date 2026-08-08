import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef LinkCallback = void Function(LinkableElement link);

abstract class LinkifyElement {
  final String text;
  final String originText;

  LinkifyElement(this.text, [String? originText]) : originText = originText ?? text;

  @override
  String toString() {
    return '$runtimeType: "$text"';
  }
}

class TextElement extends LinkifyElement {
  TextElement(super.text);
}

class LinkableElement extends LinkifyElement {
  final String url;

  LinkableElement(String? text, this.url, [String? originText]) : super(text ?? url, originText);
}

class UrlElement extends LinkableElement {
  UrlElement(String url, [String? text, String? originText]) : super(text, url, originText);
}

class EmailElement extends LinkableElement {
  final String emailAddress;

  EmailElement(this.emailAddress) : super(emailAddress, 'mailto:$emailAddress');
}

class UserTagElement extends LinkableElement {
  final String userTag;

  UserTagElement(this.userTag) : super(userTag, userTag);
}

class LinkifyOptions {
  final bool humanize;
  final bool defaultToHttps;
  final bool excludeLastPeriod;

  const LinkifyOptions({
    this.humanize = true,
    this.defaultToHttps = false,
    this.excludeLastPeriod = true,
  });
}

abstract class Linkifier {
  const Linkifier();

  List<LinkifyElement> parse(List<LinkifyElement> elements, LinkifyOptions options);
}

final _urlRegex = RegExp(r'^(.*?)(https?:\/\/\S+|www\.\S+)', caseSensitive: false, dotAll: true);

final _protocolRegex = RegExp(r'^https?:\/\/', caseSensitive: false);

final _trailingPunctRegex = RegExp(r'[.,;:!?)]$');

final _mailtoRegex = RegExp('^mailto:', caseSensitive: false);

final _wordBoundaryRegex = RegExp(r'[\w@]$');

class UrlLinkifier extends Linkifier {
  const UrlLinkifier();

  @override
  List<LinkifyElement> parse(List<LinkifyElement> elements, LinkifyOptions options) {
    final result = <LinkifyElement>[];

    for (final element in elements) {
      if (element is! TextElement) {
        result.add(element);
        continue;
      }

      final match = _urlRegex.firstMatch(element.text);
      if (match == null) {
        result.add(element);
        continue;
      }

      var remaining = element.text.replaceFirst(match.group(0)!, '');

      if (match.group(1)?.isNotEmpty ?? false) {
        result.add(TextElement(match.group(1)!));
      }

      if (match.group(2)?.isNotEmpty ?? false) {
        var matchedUrl = match.group(2)!;
        var originText = matchedUrl;
        var trailing = '';

        if (options.excludeLastPeriod && matchedUrl.endsWith('.')) {
          matchedUrl = matchedUrl.substring(0, matchedUrl.length - 1);
          originText = originText.substring(0, originText.length - 1);
          trailing = '.$remaining';
          remaining = '';
        } else {
          while (true) {
            final punct = _trailingPunctRegex.firstMatch(matchedUrl);
            if (punct != null) {
              trailing = punct.group(0)! + trailing;
              matchedUrl = matchedUrl.substring(0, matchedUrl.length - 1);
            } else {
              break;
            }
          }
        }
        var fullUrl = matchedUrl;
        if (!fullUrl.startsWith(_protocolRegex)) {
          fullUrl = '${options.defaultToHttps ? 'https' : 'http'}://$matchedUrl';
        }

        if (options.humanize) {
          final displayText = fullUrl.replaceFirst(_protocolRegex, '');
          result.add(UrlElement(fullUrl, displayText, originText));
        } else {
          result.add(UrlElement(fullUrl, null, originText));
        }

        if (trailing.isNotEmpty) {
          result.add(TextElement(trailing));
        }
      }

      if (remaining.isNotEmpty) {
        result.addAll(parse([TextElement(remaining)], options));
      }
    }

    return result;
  }
}

final _emailRegex = RegExp(
  r'^(.*?)((?:mailto:)?[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,})',
  caseSensitive: false,
  dotAll: true,
);

class EmailLinkifier extends Linkifier {
  const EmailLinkifier();

  @override
  List<LinkifyElement> parse(List<LinkifyElement> elements, LinkifyOptions options) {
    final result = <LinkifyElement>[];

    for (final element in elements) {
      if (element is! TextElement) {
        result.add(element);
        continue;
      }

      final match = _emailRegex.firstMatch(element.text);
      if (match == null) {
        result.add(element);
        continue;
      }

      final remaining = element.text.replaceFirst(match.group(0)!, '');

      if (match.group(1)?.isNotEmpty ?? false) {
        result.add(TextElement(match.group(1)!));
      }

      if (match.group(2)?.isNotEmpty ?? false) {
        final email = match.group(2)!.replaceFirst(_mailtoRegex, '');
        result.add(EmailElement(email));
      }

      if (remaining.isNotEmpty) {
        result.addAll(parse([TextElement(remaining)], options));
      }
    }

    return result;
  }
}

final _userTagRegex = RegExp(r'^(.*?)(@[\w@]+(?:[.!][\w@]+)*)', caseSensitive: false, dotAll: true);

class UserTagLinkifier extends Linkifier {
  const UserTagLinkifier();

  @override
  List<LinkifyElement> parse(List<LinkifyElement> elements, LinkifyOptions options) {
    final result = <LinkifyElement>[];

    for (final element in elements) {
      if (element is! TextElement) {
        result.add(element);
        continue;
      }

      var match = _userTagRegex.firstMatch(element.text);
      if (match == null) {
        result.add(element);
        continue;
      }

      var textRemaining = element.text.replaceFirst(match.group(0)!, '');
      final preText = StringBuffer();

      while (match?.group(1)?.contains(_wordBoundaryRegex) ?? false) {
        preText.write(match!.group(0));
        match = _userTagRegex.firstMatch(textRemaining);
        if (match == null) {
          preText.write(textRemaining);
          textRemaining = '';
        } else {
          textRemaining = textRemaining.replaceFirst(match.group(0)!, '');
        }
      }

      if (preText.isNotEmpty || (match?.group(1)?.isNotEmpty ?? false)) {
        result.add(TextElement(preText.toString() + (match?.group(1) ?? '')));
      }

      if (match?.group(2)?.isNotEmpty ?? false) {
        result.add(UserTagElement(match!.group(2)!));
      }

      if (textRemaining.isNotEmpty) {
        result.addAll(parse([TextElement(textRemaining)], options));
      }
    }

    return result;
  }
}

const List<Linkifier> defaultLinkifiers = [UrlLinkifier(), EmailLinkifier()];

List<LinkifyElement> linkify(
  String text, {
  LinkifyOptions options = const LinkifyOptions(),
  List<Linkifier> linkifiers = defaultLinkifiers,
}) {
  var elements = <LinkifyElement>[TextElement(text)];

  if (text.isEmpty) {
    return [];
  }

  for (final linkifier in linkifiers) {
    elements = linkifier.parse(elements, options);
  }

  return elements;
}

TextSpan buildTextSpan(
  List<LinkifyElement> elements, {
  TextStyle? style,
  TextStyle? linkStyle,
  LinkCallback? onOpen,
}) {
  final children = <InlineSpan>[];

  for (final element in elements) {
    if (element is LinkableElement) {
      children.add(
        TextSpan(
          text: element.text,
          style: linkStyle,
          recognizer: onOpen != null
              ? (TapGestureRecognizer()..onTap = () => onOpen(element))
              : null,
        ),
      );
    } else {
      children.add(TextSpan(text: element.text, style: style));
    }
  }

  return TextSpan(children: children);
}

class Linkify extends StatelessWidget {
  final String text;
  final List<Linkifier> linkifiers;
  final LinkCallback? onOpen;
  final LinkifyOptions options;
  final TextStyle? style;
  final TextStyle? linkStyle;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final TextOverflow overflow;
  final TextScaler? textScaler;

  const Linkify({
    super.key,
    required this.text,
    this.linkifiers = defaultLinkifiers,
    this.onOpen,
    this.options = const LinkifyOptions(),
    this.style,
    this.linkStyle,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.textScaler,
  });

  @override
  Widget build(BuildContext context) {
    final elements = linkify(text, options: options, linkifiers: linkifiers);

    final defaultStyle = style ?? DefaultTextStyle.of(context).style;

    return Text.rich(
      buildTextSpan(
        elements,
        style: defaultStyle,
        onOpen: onOpen,
        linkStyle:
            linkStyle ??
            defaultStyle.copyWith(color: Colors.blueAccent, decoration: TextDecoration.underline),
      ),
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: maxLines,
      overflow: overflow,
      textScaler: textScaler,
    );
  }
}

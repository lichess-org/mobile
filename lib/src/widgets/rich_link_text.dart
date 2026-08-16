import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef LinkCallback = void Function(LinkableElement link);

/// A widget that renders [text] with URLs, email addresses and user tags
/// turned into tappable links.
class RichLinkText extends StatefulWidget {
  final String text;
  final List<Linkifier> linkifiers;
  final LinkCallback? onOpen;
  final TextStyle? style;
  final TextStyle? linkStyle;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final TextOverflow overflow;
  final TextScaler? textScaler;

  const RichLinkText({
    super.key,
    required this.text,
    this.linkifiers = defaultLinkifiers,
    this.onOpen,
    this.style,
    this.linkStyle,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.textScaler,
  });

  @override
  State<RichLinkText> createState() => _RichLinkTextState();
}

class _RichLinkTextState extends State<RichLinkText> {
  late List<LinkifyElement> _elements;
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void initState() {
    super.initState();
    _elements = linkify(widget.text, linkifiers: widget.linkifiers);
    _createRecognizers();
  }

  @override
  void didUpdateWidget(RichLinkText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.linkifiers != widget.linkifiers ||
        oldWidget.onOpen != widget.onOpen) {
      _disposeRecognizers();
      _elements = linkify(widget.text, linkifiers: widget.linkifiers);
      _createRecognizers();
    }
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  void _createRecognizers() {
    if (widget.onOpen == null) return;
    for (final element in _elements) {
      if (element is LinkableElement) {
        _recognizers.add(TapGestureRecognizer()..onTap = () => widget.onOpen!(element));
      }
    }
  }

  void _disposeRecognizers() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle = widget.style ?? DefaultTextStyle.of(context).style;

    final children = <InlineSpan>[];
    var recognizerIndex = 0;
    for (final element in _elements) {
      if (element is LinkableElement) {
        children.add(
          TextSpan(
            text: element.text,
            style:
                widget.linkStyle ??
                defaultStyle.copyWith(
                  color: Colors.blueAccent,
                  decoration: TextDecoration.underline,
                ),
            recognizer: widget.onOpen != null ? _recognizers[recognizerIndex++] : null,
          ),
        );
      } else {
        children.add(TextSpan(text: element.text, style: defaultStyle));
      }
    }

    return Text.rich(
      TextSpan(children: children),
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
      textScaler: widget.textScaler,
    );
  }
}

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

abstract class Linkifier {
  const Linkifier();

  List<LinkifyElement> parse(List<LinkifyElement> elements);
}

final _urlRegex = RegExp(r'^(.*?)(https?:\/\/\S+|www\.\S+)', caseSensitive: false, dotAll: true);

final _protocolRegex = RegExp(r'^https?:\/\/', caseSensitive: false);

final _trailingPunctRegex = RegExp(r'[.,;:!?)]$');

final _mailtoRegex = RegExp('^mailto:', caseSensitive: false);

final _wordBoundaryRegex = RegExp(r'[\w@]$');

class UrlLinkifier extends Linkifier {
  const UrlLinkifier();

  @override
  List<LinkifyElement> parse(List<LinkifyElement> elements) {
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

      final remaining = element.text.replaceFirst(match.group(0)!, '');

      if (match.group(1)?.isNotEmpty ?? false) {
        result.add(TextElement(match.group(1)!));
      }

      if (match.group(2)?.isNotEmpty ?? false) {
        var matchedUrl = match.group(2)!;
        final originText = matchedUrl;
        var trailing = '';

        while (true) {
          final punct = _trailingPunctRegex.firstMatch(matchedUrl);
          if (punct == null) break;
          if (punct.group(0)! == ')' && !_hasUnbalancedTrailingParens(matchedUrl)) break;
          trailing = punct.group(0)! + trailing;
          matchedUrl = matchedUrl.substring(0, matchedUrl.length - 1);
        }

        final fullUrl = matchedUrl.startsWith(_protocolRegex) ? matchedUrl : 'http://$matchedUrl';
        final displayText = fullUrl.replaceFirst(_protocolRegex, '');

        result.add(UrlElement(fullUrl, displayText, originText));

        if (trailing.isNotEmpty) {
          result.add(TextElement(trailing));
        }
      }

      if (remaining.isNotEmpty) {
        result.addAll(parse([TextElement(remaining)]));
      }
    }

    return result;
  }
}

bool _hasUnbalancedTrailingParens(String url) {
  var balance = 0;
  for (final char in url.split('')) {
    if (char == '(') {
      balance++;
    } else if (char == ')') {
      balance--;
    }
  }
  return balance < 0;
}

final _emailRegex = RegExp(
  r'^(.*?)((?:mailto:)?[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,})',
  caseSensitive: false,
  dotAll: true,
);

class EmailLinkifier extends Linkifier {
  const EmailLinkifier();

  @override
  List<LinkifyElement> parse(List<LinkifyElement> elements) {
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
        result.addAll(parse([TextElement(remaining)]));
      }
    }

    return result;
  }
}

final _userTagRegex = RegExp(r'^(.*?)(@[\w@]+(?:[.!][\w@]+)*)', caseSensitive: false, dotAll: true);

class UserTagLinkifier extends Linkifier {
  const UserTagLinkifier();

  @override
  List<LinkifyElement> parse(List<LinkifyElement> elements) {
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
        result.addAll(parse([TextElement(textRemaining)]));
      }
    }

    return result;
  }
}

const List<Linkifier> defaultLinkifiers = [UrlLinkifier(), EmailLinkifier()];

List<LinkifyElement> linkify(String text, {List<Linkifier> linkifiers = defaultLinkifiers}) {
  if (text.isEmpty) {
    return [];
  }

  var elements = <LinkifyElement>[TextElement(text)];

  for (final linkifier in linkifiers) {
    elements = linkifier.parse(elements);
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

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/widgets/rich_link_text.dart';

void main() {
  group('linkify', () {
    test('returns empty list for empty string', () {
      expect(linkify(''), isEmpty);
    });

    test('returns single TextElement for plain text', () {
      final result = linkify('hello world');
      expect(result, hasLength(1));
      expect(result[0], isA<TextElement>());
      expect(result[0].text, 'hello world');
    });

    test('detects http URL', () {
      final result = linkify('visit http://example.com now');
      expect(result.any((e) => e is UrlElement), isTrue);
      final url = result.firstWhere((e) => e is UrlElement) as UrlElement;
      expect(url.url, 'http://example.com');
    });

    test('detects https URL', () {
      final result = linkify('visit https://example.com now');
      final url = result.firstWhere((e) => e is UrlElement) as UrlElement;
      expect(url.url, 'https://example.com');
    });

    test('detects www URL and adds http protocol', () {
      final result = linkify('visit www.example.com now');
      final url = result.firstWhere((e) => e is UrlElement) as UrlElement;
      expect(url.url, 'http://www.example.com');
    });

    test('www URL with defaultToHttps adds https', () {
      final result = linkify(
        'visit www.example.com now',
        options: const LinkifyOptions(defaultToHttps: true),
      );
      final url = result.firstWhere((e) => e is UrlElement) as UrlElement;
      expect(url.url, 'https://www.example.com');
    });

    test('humanizes URL display text', () {
      final result = linkify(
        'visit https://example.com/path now',
        options: const LinkifyOptions(humanize: true),
      );
      final url = result.firstWhere((e) => e is UrlElement) as UrlElement;
      expect(url.text, isNot(contains('https://')));
      expect(url.url, contains('https://'));
    });

    test('does not humanize when humanize is false', () {
      final result = linkify(
        'visit https://example.com now',
        options: const LinkifyOptions(humanize: false),
      );
      final url = result.firstWhere((e) => e is UrlElement) as UrlElement;
      expect(url.text, equals(url.url));
    });

    test('excludeLastPeriod removes trailing dot from URL', () {
      final result = linkify('visit https://example.com. now');
      final url = result.firstWhere((e) => e is UrlElement) as UrlElement;
      expect(url.url, isNot(endsWith('.')));
    });

    test('detects email address', () {
      final result = linkify('contact me at user@example.com please');
      final email = result.firstWhere((e) => e is EmailElement) as EmailElement;
      expect(email.emailAddress, 'user@example.com');
      expect(email.url, 'mailto:user@example.com');
    });

    test('detects email with mailto prefix', () {
      final result = linkify('contact me at mailto:user@example.com please');
      final email = result.firstWhere((e) => e is EmailElement) as EmailElement;
      expect(email.emailAddress, 'user@example.com');
    });

    test('detects @username mention', () {
      final result = linkify(
        'hello @user123 how are you?',
        linkifiers: const [UrlLinkifier(), EmailLinkifier(), UserTagLinkifier()],
      );
      final tag = result.firstWhere((e) => e is UserTagElement) as UserTagElement;
      expect(tag.userTag, '@user123');
      expect(tag.originText, '@user123');
    });

    test('detects multiple URLs in text', () {
      final result = linkify('foo https://a.com bar https://b.com baz');
      final urls = result.whereType<UrlElement>().toList();
      expect(urls, hasLength(2));
    });

    test('detects URL at end of text', () {
      final result = linkify('visit https://example.com');
      expect(result.any((e) => e is UrlElement), isTrue);
    });

    test('detects URL at start of text', () {
      final result = linkify('https://example.com is great');
      expect(result.firstWhere((e) => e is UrlElement), isA<UrlElement>());
    });

    test('text with no links returns single TextElement', () {
      final result = linkify('plain text without any links');
      expect(result, hasLength(1));
      expect(result[0], isA<TextElement>());
    });

    test('custom linkifiers only', () {
      final result = linkify(
        'email user@test.com and @mention',
        linkifiers: const [EmailLinkifier()],
      );
      expect(result.any((e) => e is EmailElement), isTrue);
      expect(result.any((e) => e is UserTagElement), isFalse);
    });

    test('no linkifiers returns original text', () {
      final result = linkify('visit https://example.com', linkifiers: const []);
      expect(result, hasLength(1));
      expect(result[0], isA<TextElement>());
      expect(result[0].text, 'visit https://example.com');
    });

    test('preserves text before and after URL', () {
      final result = linkify('before https://example.com after');
      final texts = result.whereType<TextElement>().toList();
      expect(texts.any((t) => t.text == 'before '), isTrue);
      expect(texts.any((t) => t.text == ' after'), isTrue);
    });

    test('preserves originText on UrlElement', () {
      final result = linkify('foo www.example.com bar');
      final url = result.firstWhere((e) => e is UrlElement) as UrlElement;
      expect(url.originText, 'www.example.com');
    });

    test('LinkifyElement originText defaults to text', () {
      final elem = TextElement('hello');
      expect(elem.originText, 'hello');
    });
  });

  group('buildTextSpan', () {
    test('returns TextSpan with children for links and text', () {
      final elements = linkify('hello https://example.com world');
      final span = buildTextSpan(elements);
      expect(span.children, isNotNull);
      expect(span.children!.length, greaterThan(1));
    });

    test('applies linkStyle to link spans', () {
      const linkStyle = TextStyle(color: Colors.red, fontWeight: FontWeight.bold);
      final elements = linkify('hello https://example.com');
      final span = buildTextSpan(elements, linkStyle: linkStyle, onOpen: (_) {});

      final linkSpan =
          span.children!.firstWhere((c) => (c as TextSpan).recognizer != null) as TextSpan;
      expect(linkSpan.style, linkStyle);
    });

    test('applies style to text spans', () {
      const style = TextStyle(color: Colors.green);
      final elements = linkify('hello world');
      final span = buildTextSpan(elements, style: style);

      final textSpan =
          span.children!.firstWhere((c) => c is TextSpan && c.recognizer == null) as TextSpan;
      expect(textSpan.style, style);
    });

    test('onOpen adds TapGestureRecognizer to links', () {
      LinkableElement? tappedLink;
      final elements = linkify('hello https://example.com');
      final span = buildTextSpan(elements, onOpen: (link) => tappedLink = link);

      final linkSpan =
          span.children!.firstWhere((c) => (c as TextSpan).recognizer != null) as TextSpan;
      expect(linkSpan.recognizer, isA<TapGestureRecognizer>());
      final tapRecognizer = linkSpan.recognizer! as TapGestureRecognizer;
      expect(tapRecognizer, isNotNull);
      tapRecognizer.onTap!();
      expect(tappedLink, isNotNull);
      expect(tappedLink!.url, 'https://example.com');
    });

    test('elements without links have no recognizer', () {
      final elements = linkify('hello world');
      final span = buildTextSpan(elements);

      for (final child in span.children ?? <InlineSpan>[]) {
        if (child is TextSpan) {
          expect(child.recognizer, isNull);
        }
      }
    });
  });

  group('Linkify widget', () {
    testWidgets('renders plain text', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Linkify(text: 'hello world')));
      expect(find.text('hello world'), findsOneWidget);
    });

    testWidgets('renders multiple elements', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Linkify(text: 'before https://a.com after')));
      expect(find.byType(RichText), findsOneWidget);
      final richText = tester.widget<RichText>(find.byType(RichText));
      final plainText = richText.text.toPlainText();
      expect(plainText, contains('before'));
      expect(plainText, contains('after'));
    });

    testWidgets('onOpen callback is wired into TextSpan recognizer', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Linkify(text: 'tap https://example.com', onOpen: (_) {}),
        ),
      );

      final richText = tester.widget<RichText>(find.byType(RichText));
      final outer = richText.text as TextSpan;
      final inner = outer.children!.first as TextSpan;
      final hasRecognizer = inner.children!.any((c) => c is TextSpan && c.recognizer != null);
      expect(hasRecognizer, isTrue);
    });

    testWidgets('passes maxLines and overflow', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SizedBox(
            width: 100,
            child: Linkify(
              text: 'very long text that should definitely overflow the given width',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );

      final richText = tester.widget<RichText>(find.byType(RichText));
      expect(richText.maxLines, 1);
      expect(richText.overflow, TextOverflow.ellipsis);
    });

    testWidgets('applies custom style and linkStyle', (WidgetTester tester) async {
      const customStyle = TextStyle(color: Colors.green, fontSize: 20.0);

      await tester.pumpWidget(
        const MaterialApp(
          home: Linkify(text: 'plain text no links', style: customStyle),
        ),
      );

      final richText = tester.widget<RichText>(find.byType(RichText));
      final outer = richText.text as TextSpan;
      final inner = outer.children!.first as TextSpan;
      expect(inner.children, isNotEmpty);
      final child = inner.children!.first as TextSpan;
      expect(child.style, isNotNull);
    });
  });
}

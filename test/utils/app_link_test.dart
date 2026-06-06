import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/widgets/app_link.dart';
import 'package:lichess_mobile/src/widgets/app_link_parser.dart';

void main() {
  group('AppLinkParser', () {
    test('returns single TextChunk when no links', () {
      final result = AppLinkParser.parse('hello world');

      expect(result.length, 1);
      expect(result.first, isA<TextChunk>());
      expect((result.first as TextChunk).text, 'hello world');
    });

    test('parses mention only', () {
      final result = AppLinkParser.parse('@user');

      expect(result.length, 1);
      final chunk = result.first as LinkChunk;

      expect(chunk.text, '@user');
      expect(chunk.link, isA<MentionLink>());
      expect((chunk.link as MentionLink).username, 'user');
    });

    test('parses url only', () {
      final result = AppLinkParser.parse('https://example.com');

      expect(result.length, 1);
      final chunk = result.first as LinkChunk;

      expect(chunk.text, 'https://example.com');
      expect(chunk.link, isA<UrlLink>());
      expect((chunk.link as UrlLink).uri.toString(), 'https://example.com');
    });

    test('parses mixed text with mention and url', () {
      final result = AppLinkParser.parse('hi @user visit https://example.com');

      expect(result.length, 4);
      expect(result[0], isA<TextChunk>()); // "hi "
      expect(result[1], isA<LinkChunk>()); // @user
      expect(result[2], isA<TextChunk>()); // " visit "
      expect(result[3], isA<LinkChunk>()); // url
    });

    test('preserves text between links', () {
      final result = AppLinkParser.parse('a @user b');

      expect(result.length, 3);
      expect((result[0] as TextChunk).text, 'a ');
      expect((result[1] as LinkChunk).text, '@user');
      expect((result[2] as TextChunk).text, ' b');
    });

    test('handles adjacent tokens', () {
      final result = AppLinkParser.parse('@user@admin');

      expect(result.length, 2);
      expect((result[0] as LinkChunk).text, '@user');
      expect((result[1] as LinkChunk).text, '@admin');
    });

    test('handles trailing text', () {
      final result = AppLinkParser.parse('@user end');

      expect(result.length, 2);
      expect((result[1] as TextChunk).text, ' end');
    });
  });
}

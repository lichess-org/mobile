import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/app_links_service.dart';
import 'package:lichess_mobile/src/widgets/app_link.dart';
import 'package:lichess_mobile/src/widgets/app_linkify.dart';

class FakeAppLinksService implements AppLinksService {
  AppLink? tappedLink;
  BuildContext? tappedContext;

  @override
  Future<void> onLinkTap(BuildContext context, AppLink link) async {
    tappedContext = context;
    tappedLink = link;
  }

  @override
  void dispose() {}

  @override
  Future<void> handleAppLink(
    BuildContext context,
    Uri uri, {
    bool animated = true,
    bool allowBrowserFallback = true,
  }) async {}

  @override
  Future<void> handleDailyPuzzleLink(
    BuildContext context,
    String? puzzleId, {
    bool animated = true,
  }) async {}

  @override
  Ref get ref => throw UnimplementedError('FakeAppLinksService does not support Riverpod ref');

  @override
  Future<List<Route<dynamic>>?> resolveAppLinkUri(BuildContext context, Uri appLinkUri) async {
    return null;
  }

  @override
  Future<void> start() async {}
}

void main() {
  group('AppLinkify', () {
    testWidgets('parses and renders spans correctly', (tester) async {
      final service = FakeAppLinksService();

      await tester.pumpWidget(
        MaterialApp(
          home: AppLinkify(text: 'hi @user visit https://example.com', linkService: service),
        ),
      );

      final richText = tester.widget<RichText>(find.byType(RichText));
      final span = richText.text as TextSpan;

      final texts = <String>[];

      void collect(TextSpan s) {
        if (s.text != null) texts.add(s.text!);
        s.children?.forEach((child) {
          if (child is TextSpan) collect(child);
        });
      }

      collect(span);

      expect(texts.contains('hi '), true);
      expect(texts.contains('@user'), true);
      expect(texts.contains(' visit '), true);
      expect(texts.contains('https://example.com'), true);
    });

    testWidgets('calls linkService.onLinkTap when tapped', (tester) async {
      final service = FakeAppLinksService();

      await tester.pumpWidget(
        MaterialApp(
          home: AppLinkify(text: 'hi @user', linkService: service),
        ),
      );

      final richText = tester.widget<RichText>(find.byType(RichText));
      final span = richText.text as TextSpan;

      TapGestureRecognizer? recognizer;

      final recognizers = <TapGestureRecognizer>[];

      void collect(TextSpan s) {
        final r = s.recognizer;
        if (r is TapGestureRecognizer) recognizers.add(r);

        s.children?.forEach((child) {
          if (child is TextSpan) collect(child);
        });
      }

      collect(span);

      expect(recognizers, isNotEmpty);
      recognizer = recognizers.first;

      recognizer.onTap?.call();

      expect(service.tappedLink, isA<MentionLink>());
      expect(service.tappedLink is MentionLink, true);
    });

    testWidgets('applies linkStyle to link spans', (tester) async {
      const linkStyle = TextStyle(color: Colors.red);

      final service = FakeAppLinksService();

      await tester.pumpWidget(
        MaterialApp(
          home: AppLinkify(text: '@user', linkService: service, linkStyle: linkStyle),
        ),
      );

      final richText = tester.widget<RichText>(find.byType(RichText));
      final span = richText.text as TextSpan;

      final linkSpan = span.children!.first as TextSpan;

      expect(linkSpan.style, linkStyle);
    });
  });
}

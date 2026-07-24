import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';

void main() {
  group('l10nWithWidget', () {
    const widget = Text('I am a widget');
    test('placeholder in the middle', () {
      final text = l10nWithWidget((_) => 'foo %s bar', widget);
      final children = (text.textSpan as TextSpan?)?.children;
      expect(children!.length, 3);
      expect((children[0] as TextSpan).text, 'foo ');
      expect((children[1] as WidgetSpan).child, widget);
      expect((children[2] as TextSpan).text, ' bar');
    });

    test('no placeholder', () {
      final text = l10nWithWidget((_) => 'foo bar', widget);
      expect(text.data, 'foo bar');
    });

    test('placeholder at the beginning', () {
      final text = l10nWithWidget((_) => '%s foo bar', widget);
      final children = (text.textSpan as TextSpan?)?.children;
      expect(children!.length, 2);
      expect((children[0] as WidgetSpan).child, widget);
      expect((children[1] as TextSpan).text, ' foo bar');
    });

    test('placeholder at the end', () {
      final text = l10nWithWidget((_) => 'foo bar %s', widget);
      final children = (text.textSpan as TextSpan?)?.children;
      expect(children!.length, 2);
      expect((children[0] as TextSpan).text, 'foo bar ');
      expect((children[1] as WidgetSpan).child, widget);
    });

    test('passes textStyle', () {
      final text = l10nWithWidget(
        (_) => 'foo %s bar',
        widget,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      );
      final children = (text.textSpan as TextSpan?)?.children;
      expect(children!.length, 3);
      expect((children[0] as TextSpan).style?.fontWeight, FontWeight.bold);
      expect((children[1] as WidgetSpan).child, widget);
      expect((children[2] as TextSpan).style?.fontWeight, FontWeight.bold);
    });
  });

  group('localesSortedByLocalizedName', () {
    test('sorts by native name, grouping scripts together', () {
      const locales = [
        Locale('ru'), // русский язык (Cyrillic)
        Locale('en'), // English (Latin)
        Locale('ko'), // 한국어 (Hangul)
        Locale('fr'), // Français (Latin)
        Locale('ar'), // العربية (Arabic)
      ];

      final sorted = localesSortedByLocalizedName(locales);

      // Unicode ordering: Latin, then Cyrillic (U+04xx), Arabic (U+06xx), Hangul.
      expect(sorted.map(localeToLocalizedName).toList(), [
        'English',
        'Français',
        'русский язык',
        'العربية',
        '한국어',
      ]);
    });

    test('does not mutate the input list', () {
      const locales = [Locale('ru'), Locale('en')];
      localesSortedByLocalizedName(locales);
      expect(locales, const [Locale('ru'), Locale('en')]);
    });

    test('all supported locales are sorted by their localized name', () {
      final sorted = localesSortedByLocalizedName(AppLocalizations.supportedLocales);
      final names = sorted.map(localeToLocalizedName).toList();
      final expected = [...names]..sort();
      expect(names, expected);
      expect(sorted.length, AppLocalizations.supportedLocales.length);
    });
  });
}

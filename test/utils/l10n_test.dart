import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

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
}

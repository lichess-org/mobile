import 'package:chessground/chessground.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';
import 'package:material_ui/material_ui.dart';

/// Every NAG code known to the canonical annotation table.
const knownNags = <int, (String, Color)>{
  1: ('!', Colors.lightGreen),
  2: ('?', LichessColors.mistake),
  3: ('!!', Colors.teal),
  4: ('??', LichessColors.blunder),
  5: ('!?', Colors.purple),
  6: ('?!', LichessColors.inaccuracy),
  8: ('□', Colors.grey),
  10: ('=', Colors.grey),
  11: ('=', Colors.grey),
  13: ('∞', Colors.grey),
  14: ('⩲', Colors.grey),
  15: ('⩱', Colors.grey),
  16: ('±', Colors.grey),
  17: ('∓', Colors.grey),
  18: ('+-', Colors.grey),
  19: ('-+', Colors.grey),
  22: ('⨀', Colors.grey),
  32: ('⟳', Colors.grey),
  36: ('↑', Colors.grey),
  44: ('=∞', Colors.grey),
  132: ('⇆', Colors.grey),
  138: ('⊕', Colors.grey),
  140: ('∆', Colors.grey),
  146: ('N', Colors.grey),
};

void main() {
  group('moveAnnotationChar', () {
    test('returns the symbol for each known NAG', () {
      for (final entry in knownNags.entries) {
        expect(moveAnnotationChar([entry.key]), entry.value.$1, reason: 'NAG ${entry.key}');
      }
    });

    test('joins symbols of multiple NAGs', () {
      expect(moveAnnotationChar([1, 2]), '!?');
      expect(moveAnnotationChar([1, 42, 2]), '!?');
    });

    test('returns empty string for unknown NAG', () {
      expect(moveAnnotationChar([99]), '');
      expect(moveAnnotationChar([]), '');
    });
  });

  group('makeAnnotation', () {
    test('returns the (symbol, color) pair for each known NAG', () {
      for (final entry in knownNags.entries) {
        expect(
          makeAnnotation([entry.key]),
          Annotation(symbol: entry.value.$1, color: entry.value.$2),
          reason: 'NAG ${entry.key}',
        );
      }
    });

    test('uses only the first NAG', () {
      expect(makeAnnotation([1, 4]), const Annotation(symbol: '!', color: Colors.lightGreen));
    });

    test('returns null for missing or unknown NAG', () {
      expect(makeAnnotation(null), isNull);
      expect(makeAnnotation([]), isNull);
      expect(makeAnnotation([99]), isNull);
    });
  });

  group('symbol parity', () {
    test('makeAnnotation and moveAnnotationChar agree on every known NAG', () {
      for (final nag in knownNags.keys) {
        final annotation = makeAnnotation([nag]);
        expect(annotation?.symbol, moveAnnotationChar([nag]), reason: 'NAG $nag');
      }
    });
  });
}

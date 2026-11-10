import 'package:chessground/chessground.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  group('moveAnnotationChar', () {
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
    test('uses only the first NAG', () {
      expect(makeAnnotation([1, 4]), const Annotation(symbol: '!', color: Colors.lightGreen));
    });

    test('returns null for missing or unknown NAG', () {
      expect(makeAnnotation(null), isNull);
      expect(makeAnnotation([]), isNull);
      expect(makeAnnotation([99]), isNull);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';

void main() {
  group('Eval.evalString (centipawn formatting)', () {
    test('formats small positive cp with sign', () {
      expect(const ExternalEval(cp: 50, mate: null).evalString, '+0.5');
    });

    test('formats small negative cp with sign', () {
      expect(const ExternalEval(cp: -120, mate: null).evalString, '-1.2');
    });

    test('formats zero cp without sign', () {
      expect(const ExternalEval(cp: 0, mate: null).evalString, '0.0');
    });

    test('returns "-" when both cp and mate are null', () {
      expect(const ExternalEval(cp: null, mate: null).evalString, '-');
    });

    test('formats mate with leading #', () {
      expect(const ExternalEval(cp: null, mate: 3).evalString, '#3');
      expect(const ExternalEval(cp: null, mate: -2).evalString, '#-2');
    });

    test('clamps very large positive cp to +99.0', () {
      expect(const ExternalEval(cp: 20000, mate: null).evalString, '+99.0');
    });

    test('clamps very large negative cp to -99.0', () {
      expect(const ExternalEval(cp: -20000, mate: null).evalString, '-99.0');
    });

    test('does not clamp cp at exactly +/-9900 boundary', () {
      expect(const ExternalEval(cp: 9900, mate: null).evalString, '+99.0');
      expect(const ExternalEval(cp: -9900, mate: null).evalString, '-99.0');
    });

    test('clamping does not affect mate scores', () {
      expect(const ExternalEval(cp: null, mate: 200).evalString, '#200');
      expect(const ExternalEval(cp: null, mate: -150).evalString, '#-150');
    });
  });
}

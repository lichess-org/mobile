import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_storm.dart';

void main() {
  group('StormCombo', () {
    test('currentLevel returns correct level', () {
      const combo = StormCombo(current: 13, best: 20);
      expect(combo.currentLevel(), 2);
    });

    test('nextLevel returns correct level', () {
      const combo = StormCombo(current: 4, best: 20);
      expect(combo.nextLevel(), 1);
    });

    test('percent returns correct percentage', () {
      const combo = StormCombo(current: 7, best: 20);
      expect(combo.percent(getNext: false), 40.0);
    });

    test('percent getNext returns correct percentage', () {
      const combo = StormCombo(current: 7, best: 20);
      expect(combo.percent(getNext: true), 60.0);
    });

    test('bonus returns correct bonus duration', () {
      const combo = StormCombo(current: 5, best: 20);
      expect(combo.bonus(getNext: false), const Duration(seconds: 3));
    });

    test('bonus returns null when no bonus is applicable', () {
      const combo = StormCombo(current: 6, best: 20);
      expect(combo.bonus(getNext: false), null);
    });

    test('bonus getNext returns correct bonus duration', () {
      const combo = StormCombo(current: 4, best: 20);
      expect(combo.bonus(getNext: true), const Duration(seconds: 3));
    });

    test('bonus getNext returns null when no bonus is applicable', () {
      const combo = StormCombo(current: 5, best: 20);
      expect(combo.bonus(getNext: true), null);
    });
  });
}

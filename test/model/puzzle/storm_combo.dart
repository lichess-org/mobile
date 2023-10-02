import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/puzzle/storm_controller.dart';

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
      expect(combo.percent(getNext: false), 28.57142857142857);
    });

    test('percent getNext returns correct percentage', () {
      const combo = StormCombo(current: 7, best: 20);
      expect(combo.percent(getNext: true), 42.857142857142854);
    });

    test('bonus current: 5', () {
      const combo = StormCombo(current: 5, best: 20);
      expect(combo.bonus(getNext: false), const Duration(seconds: 3));
    });

    test('bonus current: 6', () {
      const combo = StormCombo(current: 6, best: 20);
      expect(combo.bonus(getNext: false), null);
    });

    test('bonus current: 4 getNext', () {
      const combo = StormCombo(current: 4, best: 20);
      expect(combo.bonus(getNext: true), const Duration(seconds: 3));
    });

    test('bonus current 5 getNext', () {
      const combo = StormCombo(current: 5, best: 20);
      expect(combo.bonus(getNext: true), null);
    });
  });
}

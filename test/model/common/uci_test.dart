import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';

void main() {
  test('UciCharPair', () {
    // regular moves
    expect(UciCharPair.fromMove(Move.parse('a1b1')!).toString(), '#\$');
    expect(UciCharPair.fromMove(Move.parse('a1a2')!).toString(), '#+');
    expect(UciCharPair.fromMove(Move.parse('h7h8')!).toString(), 'Zb');

    // promotions
    expect(UciCharPair.fromMove(Move.parse('b7b8q')!).toString(), 'Td');
    expect(UciCharPair.fromMove(Move.parse('b7c8q')!).toString(), 'Te');
    expect(UciCharPair.fromMove(Move.parse('b7c8n')!).toString(), 'T}');

    // drops
    expect(UciCharPair.fromMove(Move.parse('P@a1')!).toString(), '#\x8f');
    expect(UciCharPair.fromMove(Move.parse('Q@h8')!).toString(), 'b\x8b');
  });

  group('UciPath', () {
    test('UciPath.size', () {
      expect(UciPath.empty.size, 0);
      expect(const UciPath('Td').size, 1);
      expect(const UciPath('TdTe').size, 2);
    });

    test('UciPath.head', () {
      expect(UciPath.empty.head, null);
      expect(const UciPath('Td').head, const UciCharPair('T', 'd'));
      expect(const UciPath('TdTe').head, const UciCharPair('T', 'd'));
    });

    test('UciPath.tail', () {
      expect(UciPath.empty.tail, UciPath.empty);
      expect(const UciPath('Td').tail, UciPath.empty);
      expect(const UciPath('TdTe').tail, const UciPath('Te'));
      expect(const UciPath('TdTeTf').tail, const UciPath('TeTf'));
    });

    test('UciPath.penultimate', () {
      expect(UciPath.empty.penultimate, UciPath.empty);
      expect(const UciPath('Td').penultimate, UciPath.empty);
      expect(const UciPath('TdTe').penultimate, const UciPath('Td'));
    });

    test('UciPath.last', () {
      expect(UciPath.empty.last, null);
      expect(const UciPath('Td').last, const UciCharPair('T', 'd'));
      expect(const UciPath('TdTe').last, const UciCharPair('T', 'e'));
    });

    test('UciPath.contains', () {
      expect(UciPath.empty.contains(UciPath.empty), true);
      expect(const UciPath('Td').contains(UciPath.empty), true);
      expect(const UciPath('Td').contains(const UciPath('Td')), true);
      expect(const UciPath('Td').contains(const UciPath('Te')), false);
      expect(const UciPath('TdTe').contains(const UciPath('Td')), true);
      expect(const UciPath('TdTe').contains(const UciPath('Te')), false);
      expect(const UciPath('TdTe').contains(const UciPath('Tf')), false);
    });
  });
}

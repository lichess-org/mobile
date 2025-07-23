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

    test('UciPath.operator []', () {
      expect(const UciPath('Td')[0], const UciCharPair('T', 'd'));
      expect(const UciPath('TdTe')[0], const UciCharPair('T', 'd'));
      expect(const UciPath('TdTe')[1], const UciCharPair('T', 'e'));

      expect(() => UciPath.empty[0], throwsAssertionError);
      expect(() => const UciPath('TdTe')[2], throwsAssertionError);
      expect(() => const UciPath('TdTe')[-1], throwsAssertionError);
    });

    test('UciPath.stripPrefix', () {
      const path = UciPath('AaBbCcDdEe');
      expect(path.stripPrefix(UciPath.empty), path);
      expect(path.stripPrefix(const UciPath('Aa')), const UciPath('BbCcDdEe'));
      expect(path.stripPrefix(path), UciPath.empty);

      expect(path.stripPrefix(const UciPath('Nope')), path);
      expect(path.stripPrefix(const UciPath('Bb')), path);
    });

    test('UciPath.truncate', () {
      expect(UciPath.empty.truncate(0), UciPath.empty);
      expect(UciPath.empty.truncate(123), UciPath.empty);

      expect(const UciPath('Td').truncate(1), const UciPath('Td'));
      expect(const UciPath('TdTe').truncate(1), const UciPath('Td'));
      expect(const UciPath('TdTe').truncate(2), const UciPath('TdTe'));
      expect(const UciPath('TdTeTf').truncate(2), const UciPath('TdTe'));
      expect(const UciPath('TdTeTf').truncate(3), const UciPath('TdTeTf'));
      expect(const UciPath('TdTeTf').truncate(4), const UciPath('TdTeTf'));
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

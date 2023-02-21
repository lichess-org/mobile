import 'package:flutter_test/flutter_test.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/uci.dart';

void main() {
  test('UciCharPair', () {
    // regular moves
    expect(UciCharPair.fromMove(Move.fromUci('a1b1')!).toString(), '#\$');
    expect(UciCharPair.fromMove(Move.fromUci('a1a2')!).toString(), '#+');
    expect(UciCharPair.fromMove(Move.fromUci('h7h8')!).toString(), 'Zb');

    // promotions
    expect(UciCharPair.fromMove(Move.fromUci('b7b8q')!).toString(), 'Td');
    expect(UciCharPair.fromMove(Move.fromUci('b7c8q')!).toString(), 'Te');
    expect(UciCharPair.fromMove(Move.fromUci('b7c8n')!).toString(), 'T}');

    // drops
    expect(UciCharPair.fromMove(Move.fromUci('P@a1')!).toString(), '#\x8f');
    expect(UciCharPair.fromMove(Move.fromUci('Q@h8')!).toString(), 'b\x8b');
  });
}

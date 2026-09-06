import 'dart:typed_data';

import 'package:dartchess/dartchess.dart';
import 'package:lichess_mobile/src/model/engine/opening_book.dart';

/// One Polyglot entry, as it is stored on disk.
typedef PolyglotEntry = ({int key, int move, int weight});

/// Packs a move the way Polyglot does, from squares rather than from a UCI string.
///
/// Deliberately written out here rather than shared with `scripts/gen_maia_book.dart`: a decoder
/// checked against its own encoder proves only that they agree with each other.
int packMove(Square from, Square to, {int promotion = 0}) =>
    to.file.value |
    to.rank.value << 3 |
    from.file.value << 6 |
    from.rank.value << 9 |
    promotion << 12;

/// Serializes [entries] as a Polyglot book, sorted by unsigned key as the format requires.
Uint8List polyglotBytes(List<PolyglotEntry> entries) {
  const signBit = 0x8000000000000000;
  final sorted = [...entries]..sort((a, b) => (a.key ^ signBit).compareTo(b.key ^ signBit));

  final bytes = ByteData(sorted.length * 16);
  for (var i = 0; i < sorted.length; i++) {
    bytes
      ..setInt64(i * 16, sorted[i].key)
      ..setUint16(i * 16 + 8, sorted[i].move)
      ..setUint16(i * 16 + 10, sorted[i].weight)
      ..setUint32(i * 16 + 12, 0);
  }
  return bytes.buffer.asUint8List();
}

/// A book holding [entries].
PolyglotBook polyglotBook(List<PolyglotEntry> entries) =>
    PolyglotBook(ByteData.sublistView(polyglotBytes(entries)));

/// A book holding the given `uci -> weight` moves for [position].
///
/// Castling has to be written as the king-to-rook move Polyglot stores, e.g. `e1h1`.
PolyglotBook bookFor(Position position, Map<String, int> moves) => polyglotBook([
  for (final entry in moves.entries)
    (key: position.zobristHash(), move: _packUci(entry.key), weight: entry.value),
]);

int _packUci(String uci) {
  final move = NormalMove.fromUci(uci);
  return packMove(
    move.from,
    move.to,
    promotion: switch (move.promotion) {
      Role.knight => 1,
      Role.bishop => 2,
      Role.rook => 3,
      Role.queen => 4,
      _ => 0,
    },
  );
}

import 'dart:math';
import 'dart:typed_data';

import 'package:dartchess/dartchess.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';

/// A move an opening book offers, with the weight the book gives it.
///
/// Weights are relative within a position and carry no meaning across positions: a move of weight
/// 500 is played five times as often as one of weight 100 in the same position.
typedef BookMove = ({UCIMove uci, int weight});

/// Shapes explorer game counts into book moves.
///
/// [cutoff] is the least share of a position's games a move needs to be offered, and [max] the
/// most moves offered at once. The defaults are the ones `scripts/gen_maia_book.dart` bakes into
/// the bundled book; a caller that is not paying for the bytes can keep more of the tail.
List<BookMove> shapeBookMoves(Map<UCIMove, int> games, {double cutoff = 0.02, int max = 6}) {
  final total = games.values.fold(0, (sum, count) => sum + count);
  if (total == 0) return const [];

  final kept = games.entries.where((move) => move.value / total >= cutoff).toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final top = kept.take(max).toList();

  final keptTotal = top.fold(0, (sum, move) => sum + move.value);
  return [
    for (final move in top)
      (uci: move.key, weight: (move.value / keptTotal * 1000).round().clamp(1, 0xffff)),
  ];
}

/// One of [moves], with probability proportional to its weight.
UCIMove? chooseWeighted(List<BookMove> moves, Random random) {
  final total = moves.fold(0, (sum, move) => sum + move.weight);
  if (total <= 0) return null;

  var choice = random.nextInt(total);
  for (final move in moves) {
    choice -= move.weight;
    if (choice < 0) return move.uci;
  }
  return moves.last.uci;
}

/// A [Polyglot](http://hgm.nubati.net/book_format.html) opening book, held in memory.
///
/// The format is an array of 16 byte entries sorted by position key, which is the Zobrist hash
/// dartchess computes — the two agree by construction, which is why `Position.zobristHash()` had
/// to land first. Entries for one position are contiguous, so a lookup is a binary search followed
/// by a walk in both directions.
class PolyglotBook {
  /// Wraps the bytes of a `.bin` file.
  ///
  /// Trailing bytes that do not make up a whole entry are ignored, which is what every other
  /// Polyglot reader does with a truncated book.
  const PolyglotBook(this._bytes);

  final ByteData _bytes;

  static const _entrySize = 16;

  /// Flipping the sign bit orders two's complement integers the way their unsigned bit patterns
  /// order, which is how a Polyglot book is sorted.
  static const _signBit = 0x8000000000000000;

  int get length => _bytes.lengthInBytes ~/ _entrySize;

  /// The moves this book offers in [position], most weighted first.
  ///
  /// Empty when the position is not in the book. Moves that are not legal in [position] are
  /// dropped rather than trusted: a key collision or a book built for other rules would otherwise
  /// hand the caller a move it cannot play.
  List<BookMove> movesFor(Position position) {
    final key = position.zobristHash();
    final found = _search(key);
    if (found < 0) return const [];

    var first = found;
    while (first > 0 && _keyAt(first - 1) == key) {
      first--;
    }

    final moves = <BookMove>[];
    for (var i = first; i < length && _keyAt(i) == key; i++) {
      final move = _decodeMove(_bytes.getUint16(i * _entrySize + 8), position);
      if (move == null) continue;
      moves.add((uci: move.uci, weight: _bytes.getUint16(i * _entrySize + 10)));
    }
    moves.sort((a, b) => b.weight.compareTo(a.weight));
    return moves;
  }

  int _keyAt(int index) => _bytes.getInt64(index * _entrySize);

  /// The index of any entry with [key], or -1.
  int _search(int key) {
    final target = key ^ _signBit;
    var low = 0;
    var high = length - 1;
    while (low <= high) {
      final middle = (low + high) ~/ 2;
      final candidate = _keyAt(middle) ^ _signBit;
      if (candidate == target) return middle;
      if (candidate < target) {
        low = middle + 1;
      } else {
        high = middle - 1;
      }
    }
    return -1;
  }

  /// Unpacks Polyglot's 16 bit move field, as a move legal in [position].
  ///
  /// Castling is stored king-to-rook (`e1h1`), so it is translated to the king's true destination,
  /// which is what the rest of the app speaks. Returns null if the result is not legal here.
  NormalMove? _decodeMove(int packed, Position position) {
    final to = Square((packed & 0x7) | ((packed >> 3) & 0x7) << 3);
    final from = Square(((packed >> 6) & 0x7) | ((packed >> 9) & 0x7) << 3);
    final promotion = switch ((packed >> 12) & 0x7) {
      1 => Role.knight,
      2 => Role.bishop,
      3 => Role.rook,
      4 => Role.queen,
      _ => null,
    };

    final castling = position.board.kings.has(from) && position.board.bySide(position.turn).has(to);
    final move = NormalMove(
      from: from,
      to: castling ? _kingDestination(from, to) : to,
      promotion: promotion,
    );
    return position.isLegal(move) ? move : null;
  }

  /// Where the king lands when castling towards the rook on [rook].
  Square _kingDestination(Square king, Square rook) {
    final rank = king.rank.value * 8;
    return Square(rank + (rook > king ? 6 : 2));
  }
}

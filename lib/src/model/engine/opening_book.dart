import 'dart:math';
import 'dart:typed_data';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer_repository.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

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
@immutable
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

/// A provider for [MaiaOfflineBookService].
final maiaBookServiceProvider = Provider<MaiaOfflineBookService>((Ref ref) {
  return MaiaOfflineBookService();
}, name: 'MaiaOfflineBookServiceProvider');

/// The opening books the Maia opponents play from, one per rating tier.
///
/// The Lichess opening explorer's move distribution differs enough between rating bands to be
/// worth splitting — 1...e5 is played by 55% of the lower band and 35% of the upper — but not
/// enough to be worth one book per network. Two books put every level within its own half of the
/// range, for ~22 KB each.
enum MaiaOfflineBookTier {
  low,
  high;

  /// The tier a Maia network plays from. The split follows the explorer's own rating buckets.
  factory MaiaOfflineBookTier.forRating(MaiaRating rating) =>
      rating.rating < 1600 ? MaiaOfflineBookTier.low : MaiaOfflineBookTier.high;

  /// Where the book ships in the asset bundle.
  String get asset => 'assets/maia/book-$name.bin';
}

/// The Maia opponent opening book of one rating tier, and the weighted choice made from it.
@immutable
class MaiaOfflineBook {
  const MaiaOfflineBook(this.book);

  final PolyglotBook book;

  /// The moves the book offers in [position], most played first.
  List<BookMove> movesFor(Position position) => book.movesFor(position);

  /// A move for [position], chosen with probability proportional to how often humans played it.
  ///
  /// Null when the position is not in the book, which is the signal to fall through to the
  /// network. [random] is injected so a game can be replayed in tests.
  UCIMove? chooseMove(Position position, Random random) =>
      chooseWeighted(book.movesFor(position), random);
}

/// Loads the Maia opening books out of the asset bundle, once each.
///
/// The books are a few tens of kilobytes, so they are kept for the life of the app rather than
/// released with the game that asked for them.
class MaiaOfflineBookService {
  MaiaOfflineBookService();

  final _logger = Logger('MaiaOfflineBook');

  final Map<MaiaOfflineBookTier, Future<MaiaOfflineBook?>> _books = {};

  /// The book [rating] plays from, or null if it could not be read.
  ///
  /// A missing or damaged book is not worth failing a move over: the opponent just plays its own
  /// opening moves, which is what it did before there was a book at all.
  Future<MaiaOfflineBook?> bookFor(MaiaRating rating) {
    final tier = MaiaOfflineBookTier.forRating(rating);
    return _books[tier] ??= _load(tier);
  }

  Future<MaiaOfflineBook?> _load(MaiaOfflineBookTier tier) async {
    try {
      final data = await rootBundle.load(tier.asset);
      final book = PolyglotBook(data);
      _logger.info('Loaded the $tier opening book: ${book.length} entries');
      return MaiaOfflineBook(book);
    } catch (e, st) {
      _logger.warning('Could not load the $tier opening book', e, st);
      return null;
    }
  }
}

/// A provider for [MaiaOnlineBook].
final maiaOnlineBookProvider = Provider<MaiaOnlineBook>((Ref ref) {
  return MaiaOnlineBook(ref);
}, name: 'MaiaOnlineBookProvider');

/// The online opening book Maia opponents play from, which reads the Lichess opening explorer.
class MaiaOnlineBook {
  MaiaOnlineBook(this._ref);

  final Ref _ref;

  final _logger = Logger('MaiaOnlineBook');

  /// Positions already looked up this session, so a rematch does not ask twice.
  final Map<(String, int), List<BookMove>> _cache = {};

  /// The explorer rating buckets, which are the lower bound of each band.
  static const _kExplorerRatings = [1000, 1200, 1400, 1600, 1800, 2000, 2200];

  /// The speeds the offline book was crawled from: bullet is noise and classical is thin.
  static const _kSpeeds = ISetConst({Speed.blitz, Speed.rapid});

  /// How long a move may wait on the explorer before the offline book answers instead.
  static const _kTimeout = Duration(milliseconds: 1500);

  /// Where the offline book stops, and so where this one does: past the opening the network should
  /// be the one deciding.
  static const _kMaxPly = 10;

  // Kept looser than the bundled book, which trades the tail away for bytes.
  static const _kCutoff = 0.01;
  static const _kMaxMoves = 10;

  /// The moves humans of [rating]'s band played in [position], most played first.
  ///
  /// Empty whenever the explorer cannot answer — offline, a failed or slow request, or a position
  /// it does not know — which is the signal to fall back to the bundled book.
  Future<List<BookMove>> movesFor(Position position, MaiaRating rating) async {
    if (position.ply >= _kMaxPly) return const [];
    if (!_ref.read(isDeviceOnlineProvider)) return const [];

    final band = _bandFor(rating);
    final key = (position.fen, band);
    final cached = _cache[key];
    if (cached != null) return cached;

    try {
      final entry = await _ref
          .read(openingExplorerRepositoryProvider)
          .getLichessDatabase(
            position.fen,
            variant: Variant.standard,
            speeds: _kSpeeds,
            ratings: ISet({band}),
          )
          .timeout(_kTimeout);

      final moves = shapeBookMoves(
        {for (final move in entry.moves) move.uci: move.games},
        cutoff: _kCutoff,
        max: _kMaxMoves,
      );
      _cache[key] = moves;
      return moves;
    } catch (e) {
      _logger.info('Could not read the online book, falling back to the bundled one: $e');
      return const [];
    }
  }

  /// The explorer band [rating] belongs to.
  int _bandFor(MaiaRating rating) =>
      _kExplorerRatings.lastWhere((band) => band <= rating.rating, orElse: () => 1000);
}

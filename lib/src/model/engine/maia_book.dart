import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/opening_book.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';
import 'package:logging/logging.dart';

final _logger = Logger('MaiaBook');

/// A provider for [MaiaBookService].
final maiaBookServiceProvider = Provider<MaiaBookService>((Ref ref) {
  return MaiaBookService();
}, name: 'MaiaBookServiceProvider');

/// The opening books the Maia opponents play from, one per rating tier.
///
/// The Lichess opening explorer's move distribution differs enough between rating bands to be
/// worth splitting — 1...e5 is played by 55% of the lower band and 35% of the upper — but not
/// enough to be worth one book per network. Two books put every level within its own half of the
/// range, for ~22 KB each.
enum MaiaBookTier {
  low,
  high;

  /// The tier a Maia network plays from. The split follows the explorer's own rating buckets.
  factory MaiaBookTier.forRating(MaiaRating rating) =>
      rating.rating < 1600 ? MaiaBookTier.low : MaiaBookTier.high;

  /// Where the book ships in the asset bundle.
  String get asset => 'assets/maia/book-$name.bin';
}

/// The opening book of one rating tier, and the weighted choice made from it.
///
/// Maia is a policy network, and a policy network is sharper than the distribution it was trained
/// on: after 1.e4 it puts ~40% on 1...e5 where humans of its rating put ~25%. The book replaces
/// its opening moves with the true human frequencies, which is both more varied and more faithful.
class MaiaBook {
  const MaiaBook(this.book);

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
class MaiaBookService {
  MaiaBookService();

  final Map<MaiaBookTier, Future<MaiaBook?>> _books = {};

  /// The book [rating] plays from, or null if it could not be read.
  ///
  /// A missing or damaged book is not worth failing a move over: the opponent just plays its own
  /// opening moves, which is what it did before there was a book at all.
  Future<MaiaBook?> bookFor(MaiaRating rating) {
    final tier = MaiaBookTier.forRating(rating);
    return _books[tier] ??= _load(tier);
  }

  Future<MaiaBook?> _load(MaiaBookTier tier) async {
    try {
      final data = await rootBundle.load(tier.asset);
      final book = PolyglotBook(data);
      _logger.info('Loaded the $tier opening book: ${book.length} entries');
      return MaiaBook(book);
    } catch (e, st) {
      _logger.warning('Could not load the $tier opening book', e, st);
      return null;
    }
  }
}

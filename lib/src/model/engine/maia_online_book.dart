import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/engine/opening_book.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer_repository.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:logging/logging.dart';

final _logger = Logger('MaiaOnlineBook');

/// A provider for [MaiaOnlineBook].
final maiaOnlineBookProvider = Provider<MaiaOnlineBook>((Ref ref) {
  return MaiaOnlineBook(ref);
}, name: 'MaiaOnlineBookProvider');

/// The explorer rating buckets, which are the lower bound of each band.
const _kExplorerRatings = [1000, 1200, 1400, 1600, 1800, 2000, 2200];

/// The speeds the offline book was crawled from: bullet is noise and classical is thin.
const _kSpeeds = ISetConst({Speed.blitz, Speed.rapid});

/// How long a move may wait on the explorer before the offline book answers instead.
const _kTimeout = Duration(milliseconds: 1500);

/// Where the offline book stops, and so where this one does: past the opening the network should
/// be the one deciding.
const _kMaxPly = 10;

/// Kept looser than the bundled book, which trades the tail away for bytes. Keeping more of it is
/// closer to what humans of the band actually played, since less mass is dropped and renormalised
/// onto the favourite.
const _kCutoff = 0.01;
const _kMaxMoves = 10;

/// The Lichess opening explorer, read at move time as an opening book.
///
/// The bundled book merges three rating buckets into one file to keep the app small; online there
/// is no such cost, so each network reads the band it was trained on.
class MaiaOnlineBook {
  MaiaOnlineBook(this._ref);

  final Ref _ref;

  /// Positions already looked up this session, so a rematch does not ask twice.
  final Map<(String, int), List<BookMove>> _cache = {};

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

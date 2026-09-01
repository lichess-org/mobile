import 'package:dartchess/dartchess.dart';
import 'package:lichess_mobile/src/model/engine/maia_online_book.dart';
import 'package:lichess_mobile/src/model/engine/opening_book.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';

/// A [MaiaOnlineBook] that answers from a map rather than from the explorer.
///
/// With nothing configured it stands for the offline case: every lookup misses, so the bundled
/// book answers instead.
class FakeMaiaOnlineBook implements MaiaOnlineBook {
  FakeMaiaOnlineBook({Map<String, List<BookMove>>? moves}) : _moves = moves ?? const {};

  final Map<String, List<BookMove>> _moves;

  /// The positions [movesFor] was asked for, in order.
  final List<String> requests = [];

  @override
  Future<List<BookMove>> movesFor(Position position, MaiaRating rating) async {
    requests.add(position.fen);
    return _moves[position.fen] ?? const [];
  }
}

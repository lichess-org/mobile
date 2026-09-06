import 'package:lichess_mobile/src/model/engine/opening_book.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';

/// A [MaiaOfflineBookService] that hands out a book given to it rather than reading the asset bundle.
///
/// With no book it stands for the case every opponent has to survive: no book asset, or one that
/// could not be read, so the opponent plays its own opening moves.
class FakeMaiaOfflineBookService implements MaiaOfflineBookService {
  FakeMaiaOfflineBookService({this.book});

  final MaiaOfflineBook? book;

  /// The ratings [bookFor] was asked for, in order.
  final List<MaiaRating> requests = [];

  @override
  Future<MaiaOfflineBook?> bookFor(MaiaRating rating) async {
    requests.add(rating);
    return book;
  }
}

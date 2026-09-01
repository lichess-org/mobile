import 'package:lichess_mobile/src/model/engine/maia_book.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';

/// A [MaiaBookService] that hands out a book given to it rather than reading the asset bundle.
///
/// With no book it stands for the case every opponent has to survive: no book asset, or one that
/// could not be read, so the opponent plays its own opening moves.
class FakeMaiaBookService implements MaiaBookService {
  FakeMaiaBookService({this.book});

  final MaiaBook? book;

  /// The ratings [bookFor] was asked for, in order.
  final List<MaiaRating> requests = [];

  @override
  Future<MaiaBook?> bookFor(MaiaRating rating) async {
    requests.add(rating);
    return book;
  }
}

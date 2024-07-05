import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/analysis/opening_explorer.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';

class OpeningExplorerRepository {
  OpeningExplorer getOpeningExplorer(String fen) {
    return OpeningExplorer(
      opening: const LightOpening(eco: 'D10', name: 'Slav Defense'),
      white: 1443,
      draws: 3787,
      black: 1156,
      moves: const [
        OpeningMove(
          uci: 'c6d5',
          san: 'cxd5',
          averageRating: 2423,
          white: 1443,
          draws: 3787,
          black: 1155,
          game: null,
        ),
        OpeningMove(
          uci: 'g8f6',
          san: 'Nf6',
          averageRating: 2515,
          white: 0,
          draws: 0,
          black: 1,
          game: null,
        ),
      ].toIList(),
      topGames: const IList.empty(),
      recentGames: const IList.empty(),
      history: const IList.empty(),
    );
  }
}

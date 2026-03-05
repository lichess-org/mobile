import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';

/// Interface for Analysis's State.
abstract class CommonAnalysisState {
  /// Returns `true` if the engine evaluation is available (for both local and cloud).
  ///
  /// This value may depend on the current state and the user preferences.
  bool isEngineAvailable(EngineEvaluationPrefState prefs);

  /// The variant of the analysis.
  Variant get variant;

  /// Current position in the position tree. Can be `null` to support illegal position that are
  /// found in studies.
  Position? get currentPosition;

  /// The current node in the analysis view.
  AnalysisCurrentNodeInterface get currentNode;

  /// The last move played.
  Move? get lastMove;

  /// The side to display the board from.
  Side get pov;

  /// Possible promotion move to be played.
  NormalMove? get promotionMove;

  /// Squares that should have an atomic explosion animation after the last move.
  ///
  /// Returns `null` if the variant is not atomic, there is no last move, or the
  /// last move was not a capture (no explosion occurs).
  ISet<Square>? get explosionSquares;

  bool get engineInThreatMode;
}

/// Mixin that computes [CommonAnalysisState.explosionSquares] for states that
/// have a position tree ([ViewRoot]) and a current path ([UciPath]).
///
/// The mixin walks up one step in the tree to find the position **before** the
/// last move, then delegates to dartchess's [Atomic.explosionSquares].
mixin AnalysisExplosionMixin implements CommonAnalysisState {
  /// The tree root used to find the parent position.
  ///
  /// Return `null` if the tree is not available (e.g. illegal starting
  /// position), in which case no explosion will be shown.
  ViewRoot? get analysisRoot;

  /// The path of the current node inside [analysisRoot].
  UciPath get currentPath;

  @override
  ISet<Square>? get explosionSquares {
    if (variant != Variant.atomic || lastMove == null || currentPath.isEmpty) return null;
    final root = analysisRoot;
    if (root == null) return null;
    final parentPos =
        root.branchesOn(currentPath.penultimate).lastOrNull?.position ?? root.position;
    if (parentPos is! Atomic) return null;
    final squareSet = parentPos.explosionSquares(lastMove!);
    return squareSet.isEmpty ? null : squareSet.squares.toISet();
  }
}

/// Interface for Analysis's current node.
abstract class AnalysisCurrentNodeInterface {
  SanMove? get sanMove;
  IList<int>? get nags;
  ClientEval? get eval;
}

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
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
}

/// Interface for Analysis's current node.
abstract class AnalysisCurrentNodeInterface {
  SanMove? get sanMove;
  IList<int>? get nags;
  ClientEval? get eval;
}

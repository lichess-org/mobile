import 'package:dartchess/dartchess.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';

/// Interface for Analysis's State.
abstract class AbstractAnalysisState {
  /// Whether computer evaluation is allowed for this analysis.
  ///
  /// Acts on both local and server analysis.
  bool get isComputerAnalysisAllowed;

  /// Whether the user has enabled server analysis.
  bool get isServerAnalysisEnabled;

  /// Returns `true` if the engine evaluation is available (for both local and cloud).
  ///
  /// This value may depend on the current state and the user preferences.
  bool isEngineAvailable(EngineEvaluationPrefState prefs);

  /// The variant of the analysis.
  Variant get variant;

  /// Current position in the position tree.
  Position get currentPosition;

  /// The current node in the analysis view.
  ///
  /// This is an immutable copy of the actual [Node] at the `currentPath`.
  /// We don't want to use [Node.view] here because it'd copy the whole tree
  /// under the current node and it's expensive.
  AnalysisCurrentNode get currentNode;

  /// The last move played.
  Move? get lastMove;

  /// The side to display the board from.
  Side get pov;

  /// Possible promotion move to be played.
  NormalMove? get promotionMove;
}

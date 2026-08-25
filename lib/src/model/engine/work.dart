import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';

part 'work.freezed.dart';

typedef EvalResult = (EvalWork, LocalEval);

/// A position to evaluate, and the settings to evaluate it with.
@freezed
sealed class EvalWork with _$EvalWork {
  const EvalWork._();

  const factory EvalWork({
    /// Identifier to associate this work with a game, puzzle, etc.
    required StringId id,

    required Variant variant,
    required int threads,
    int? hashSize,

    /// The path in the position tree. Nullable for contexts without a tree (e.g., offline games).
    UciPath? path,

    /// How long the engine may search.
    required Duration searchTime,

    /// The number of principal variations to compute.
    required int multiPv,

    /// Whether to pretend it is the opposite side's turn.
    required bool threatMode,

    bool? isDeeper,
    required Position initialPosition,
    required IList<Step> steps,
  }) = _EvalWork;

  /// The position to evaluate.
  Position get position => steps.lastOrNull?.position ?? initialPosition;

  /// Cached eval for the work position.
  ClientEval? get evalCache => steps.lastOrNull?.eval;
}

@freezed
sealed class Step with _$Step {
  const Step._();

  const factory Step({required Position position, required SanMove sanMove, ClientEval? eval}) =
      _Step;

  factory Step.fromNode(Branch node) {
    return Step(position: node.position, sanMove: node.sanMove, eval: node.eval);
  }
}

import 'package:dartchess/dartchess.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';

part 'evaluation_context.freezed.dart';

@freezed
sealed class EvaluationContext with _$EvaluationContext {
  const factory EvaluationContext({
    /// Identifier to associate the evaluation with a game, puzzle, study, etc.
    required StringId id,
    required Variant variant,
    required Position initialPosition,
  }) = _EvaluationContext;
}

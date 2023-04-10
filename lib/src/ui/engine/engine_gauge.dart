import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/eval.dart';
import 'package:lichess_mobile/src/model/engine/engine_evaluation.dart';
import 'package:lichess_mobile/src/widgets/eval_gauge.dart';

class EngineGauge extends ConsumerWidget {
  const EngineGauge({
    required this.id,
    required this.position,
    this.savedEval,
  });

  /// Unique ID corresponding to the evaluation context (game, puzzle, etc).
  final String id;

  /// Position to evaluate.
  final Position position;

  /// Saved evaluation to display when the current evaluation is not available.
  final ClientEval? savedEval;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eval = ref.watch(engineEvaluationProvider(id));

    return eval != null
        ? EvalGauge(
            position: position,
            eval: eval,
          )
        : savedEval != null
            ? EvalGauge(
                position: position,
                eval: savedEval,
              )
            : EvalGauge(position: position);
  }
}

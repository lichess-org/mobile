import 'dart:math' as math;
import 'dart:io';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/common/id.dart';

import 'engine.dart';
import 'work.dart';

part 'engine_evaluation.g.dart';
part 'engine_evaluation.freezed.dart';

// TODO: make this configurable
const kMaxDepth = 22;
const kDefaultLines = 2;

final maxCores = math.max(1, Platform.numberOfProcessors - 1);

@freezed
class EvaluationContext with _$EvaluationContext {
  const factory EvaluationContext({
    required Variant variant,
    required String initialFen,

    /// Unique ID to ensure engine is properly disposed when no more needed
    /// and a new engine instance is created per context (puzzle, game, etc).
    required ID contextId,
  }) = _EvaluationContext;
}

@riverpod
class EngineEvaluation extends _$EngineEvaluation {
  StockfishEngine? _engine;

  int _multiPv = kDefaultLines;
  int _cores = maxCores;

  @override
  ClientEval? build(EvaluationContext context) {
    ref.onDispose(() {
      _engine?.dispose();
    });
    return null;
  }

  Stream<EvalResult>? start(
    UciPath path,
    Iterable<Step> steps,
    Position position, {
    required bool Function(Work work) shouldEmit,
  }) {
    _engine ??= StockfishEngine();

    final work = Work(
      variant: context.variant,
      threads: _cores,
      maxDepth: kMaxDepth,
      multiPv: _multiPv,
      path: path,
      initialFen: context.initialFen,
      steps: IList(steps),
      currentPosition: position,
    );

    // cancel evaluation if we already have a cached eval at max depth
    final cachedEval = work.evalCache;
    if (cachedEval != null && cachedEval.depth >= kMaxDepth) {
      state = null;
      return null;
    }

    final evalStream = _engine!.start(work).throttle(
          const Duration(milliseconds: 200),
          trailing: true,
        );

    evalStream.forEach((t) {
      final (work, eval) = t;
      if (shouldEmit(work)) {
        state = eval;
      }
    });

    return evalStream;
  }

  void stop() {
    state = null;
    _engine?.stop();
  }

  // ignore:avoid_setters_without_getters
  set cores(int cores) => _cores = cores;
  // ignore:avoid_setters_without_getters
  set multiPv(int pv) => _multiPv = pv;
}

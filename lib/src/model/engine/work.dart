import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Tuple2;

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/uci.dart';
import 'package:lichess_mobile/src/common/eval.dart';
import 'package:lichess_mobile/src/common/tree.dart';

part 'work.freezed.dart';

@freezed
class Work with _$Work {
  const factory Work({
    required int threads,
    int? hashSize,
    bool? stopRequested,
    required UciPath path,
    required int maxDepth,
    required int multiPv,
    required int ply,
    bool? threatMode,
    required String initialFen,
    required String currentFen,
    required IList<UCIMove> moves,
    required void Function(Work work, ClientEval eval) emit,
  }) = _Work;
}

@freezed
class Step with _$Step {
  const Step._();

  const factory Step({
    required int ply,
    required String fen,
    required SanMove sanMove,
    ClientEval? eval,
  }) = _Step;

  factory Step.fromNode(ViewNode node) {
    return Step(
      ply: node.ply,
      fen: node.fen,
      sanMove: node.sanMove,
      eval: node.eval,
    );
  }
}

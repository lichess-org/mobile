import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tuple/tuple.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Tuple2;

import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';

part 'work.freezed.dart';

typedef EvalResult = Tuple2<Work, ClientEval>;

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
  }) = _Work;
}

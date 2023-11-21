import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/id.dart';

part 'correspondence_seek.freezed.dart';

@freezed
class CorrespondenceSeek with _$CorrespondenceSeek {
  const factory CorrespondenceSeek({
    required GameId id,
    required String username,
    required int rating,
    Variant? variant,
    required Perf perf,
    required bool rated,
    int? days,
    Side? side,
    bool? provisional,
  }) = _CorrespondenceSeek;
}

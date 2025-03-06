import 'package:dartchess/dartchess.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';

part 'correspondence_challenge.freezed.dart';

@freezed
sealed class CorrespondenceChallenge with _$CorrespondenceChallenge {
  const factory CorrespondenceChallenge({
    required GameId id,
    required String username,
    String? title,
    required int rating,
    required Variant variant,
    required Perf perf,
    required bool rated,
    int? days,
    Side? side,
    bool? provisional,
  }) = _CorrespondenceChallenge;
}

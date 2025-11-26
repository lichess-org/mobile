import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';

part 'correspondence_seek.freezed.dart';

/// A correspondence game seek in the lobby (an open challenge to play a correspondence game).
///
/// It is created from a regular [ChallengeRequest], but it is not listed in [ChallengeRepository.list]
/// because open correspondence challenges are handled differently.
/// This is what the server returns from `/lobby/seeks`.
@freezed
sealed class CorrespondenceSeek with _$CorrespondenceSeek {
  const factory CorrespondenceSeek({
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
  }) = _CorrespondenceSeek;

  factory CorrespondenceSeek.fromServerJson(Map<String, dynamic> json) =>
      _correspondenceSeekFromPick(pick(json).required());
}

CorrespondenceSeek _correspondenceSeekFromPick(RequiredPick pick) {
  return CorrespondenceSeek(
    id: pick('id').asGameIdOrThrow(),
    username: pick('username').asStringOrThrow(),
    title: pick('title').asStringOrNull(),
    rating: pick('rating').asIntOrThrow(),
    variant: pick('variant').asVariantOrThrow(),
    perf: pick('perf').asPerfOrThrow(),
    rated: pick('mode').asIntOrThrow() == 1,
    days: pick('days').asIntOrNull(),
    side: pick('color').asSideOrNull(),
    provisional: pick('provisional').asBoolOrNull(),
  );
}

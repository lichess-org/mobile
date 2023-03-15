import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Tuple2;

import 'package:lichess_mobile/src/common/models.dart';
import 'puzzle_theme.dart';

part 'puzzle_session.freezed.dart';
part 'puzzle_session.g.dart';

@Freezed(fromJson: true, toJson: true)
class PuzzleSession with _$PuzzleSession {
  const factory PuzzleSession({
    required PuzzleTheme theme,
    required IList<PuzzleAttempt> attempts,
    required DateTime lastUpdatedAt,
  }) = _PuzzleSession;

  factory PuzzleSession.initial({
    required PuzzleTheme theme,
  }) {
    return PuzzleSession(
      theme: theme,
      attempts: IList(const []),
      lastUpdatedAt: DateTime.now(),
    );
  }

  factory PuzzleSession.fromJson(Map<String, dynamic> json) =>
      _$PuzzleSessionFromJson(json);
}

@Freezed(fromJson: true, toJson: true)
class PuzzleAttempt with _$PuzzleAttempt {
  const PuzzleAttempt._();

  const factory PuzzleAttempt({
    required PuzzleId id,
    required bool win,
    int? ratingDiff,
  }) = _PuzzleAttempt;

  factory PuzzleAttempt.fromJson(Map<String, dynamic> json) =>
      _$PuzzleAttemptFromJson(json);

  String? get ratingDiffString {
    if (ratingDiff == null) return null;
    final prefix = ratingDiff! >= 0 ? '+' : '';
    return '$prefix${ratingDiff!}';
  }
}

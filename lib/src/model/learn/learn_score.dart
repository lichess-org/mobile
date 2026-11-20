import 'dart:math' as math;

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/learn/learn_level.dart';

/// Scoring of the learn levels and stages.
///
/// Mirrors `ui/learn/src/score.ts` on lichess.org, so that scores match the website.

const kLearnAppleScore = 50;
const kLearnCaptureScore = 50;
const kLearnScenarioScore = 50;

/// A rank from 1 (best, three stars) to 3 (one star).
typedef LearnRank = int;

const _levelBonus = {1: 500, 2: 300, 3: 100};

/// The bonus for completing [level] in [nbMoves] moves.
int learnLevelBonus(LearnLevel level, int nbMoves) {
  final late = nbMoves - level.nbMoves;
  if (late <= 0) return _levelBonus[1]!;
  if (late <= math.max(1, level.nbMoves / 8)) return _levelBonus[2]!;
  return _levelBonus[3]!;
}

int _levelMaxScore(LearnLevel level) =>
    level.apples.length * kLearnAppleScore +
    (level.pointsForCapture ? level.captures * kLearnCaptureScore : 0) +
    _levelBonus[1]!;

LearnRank learnLevelRank(LearnLevel level, int score) {
  final max = _levelMaxScore(level);
  return score >= max
      ? 1
      : score >= max - 200
      ? 2
      : 3;
}

LearnRank learnStageRank(LearnStage stage, IList<int> scores) {
  final max = stage.levels.fold(0, (sum, level) => sum + _levelMaxScore(level));
  final score = scores.fold(0, (a, b) => a + b);
  return score >= max
      ? 1
      : score >= max - math.max(200, stage.levels.length * 150)
      ? 2
      : 3;
}

/// The points for capturing a piece of [role] in levels that show piece values.
int learnPieceValue(Role role) => switch (role) {
  Role.queen => 90,
  Role.rook => 50,
  Role.bishop => 30,
  Role.knight => 30,
  Role.pawn => 10,
  Role.king => 0,
};

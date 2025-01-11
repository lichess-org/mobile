import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

enum PuzzleDifficulty {
  easiest(-600),
  easier(-300),
  normal(0),
  harder(300),
  hardest(600);

  final int ratingDelta;
  const PuzzleDifficulty(this.ratingDelta);
}

final IMap<String, PuzzleDifficulty> puzzleDifficultyNameMap = IMap(
  PuzzleDifficulty.values.asNameMap(),
);

String puzzleDifficultyL10n(BuildContext context, PuzzleDifficulty difficulty) {
  switch (difficulty) {
    case PuzzleDifficulty.easiest:
      return context.l10n.puzzleEasiest;
    case PuzzleDifficulty.easier:
      return context.l10n.puzzleEasier;
    case PuzzleDifficulty.normal:
      return context.l10n.normal;
    case PuzzleDifficulty.harder:
      return context.l10n.puzzleHarder;
    case PuzzleDifficulty.hardest:
      return context.l10n.puzzleHardest;
  }
}

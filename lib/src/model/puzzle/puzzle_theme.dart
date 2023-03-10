import 'package:flutter/widgets.dart';
import 'package:tuple/tuple.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Tuple2;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/common/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

part 'puzzle_theme.g.dart';

enum PuzzleTheme {
  mix,
  advancedPawn,
  advantage,
  anastasiaMate,
  arabianMate,
  attackingF2F7,
  attraction,
  backRankMate,
  bishopEndgame,
  bodenMate,
  capturingDefender,
  castling,
  clearance,
  crushing,
  defensiveMove,
  deflection,
  discoveredAttack,
  doubleBishopMate,
  doubleCheck,
  dovetailMate,
  equality,
  endgame,
  enPassant,
  exposedKing,
  fork,
  hangingPiece,
  hookMate,
  interference,
  intermezzo,
  kingsideAttack,
  knightEndgame,
  long,
  master,
  masterVsMaster,
  mate,
  mateIn1,
  mateIn2,
  mateIn3,
  mateIn4,
  mateIn5,
  smotheredMate,
  middlegame,
  oneMove,
  opening,
  pawnEndgame,
  pin,
  promotion,
  queenEndgame,
  queenRookEndgame,
  queensideAttack,
  quietMove,
  rookEndgame,
  sacrifice,
  short,
  skewer,
  superGM,
  trappedPiece,
  underPromotion,
  veryLong,
  xRayAttack,
  zugzwang,
  // checkFirst,
}

final IMap<String, PuzzleTheme> puzzleThemeNameMap =
    IMap(PuzzleTheme.values.asNameMap());

typedef PuzzleThemeCategory = Tuple2<String, List<PuzzleTheme>>;

@Riverpod(keepAlive: true)
IList<PuzzleThemeCategory> puzzleThemeCategories(
  PuzzleThemeCategoriesRef ref,
) {
  final l10n = ref.watch(l10nProvider);

  return IList([
    Tuple2(
      l10n.recommended,
      [
        PuzzleTheme.mix,
      ],
    ),
    Tuple2(
      l10n.phases,
      [
        PuzzleTheme.opening,
        PuzzleTheme.middlegame,
        PuzzleTheme.endgame,
        PuzzleTheme.rookEndgame,
        PuzzleTheme.bishopEndgame,
        PuzzleTheme.pawnEndgame,
        PuzzleTheme.knightEndgame,
        PuzzleTheme.queenEndgame,
        PuzzleTheme.queenRookEndgame,
      ],
    ),
    Tuple2(
      l10n.motifs,
      [
        PuzzleTheme.advancedPawn,
        PuzzleTheme.attackingF2F7,
        PuzzleTheme.capturingDefender,
        PuzzleTheme.discoveredAttack,
        PuzzleTheme.doubleCheck,
        PuzzleTheme.exposedKing,
        PuzzleTheme.fork,
        PuzzleTheme.hangingPiece,
        PuzzleTheme.kingsideAttack,
        PuzzleTheme.pin,
        PuzzleTheme.queensideAttack,
        PuzzleTheme.sacrifice,
        PuzzleTheme.skewer,
        PuzzleTheme.trappedPiece,
      ],
    ),
    Tuple2(
      l10n.advanced,
      [
        PuzzleTheme.attraction,
        PuzzleTheme.clearance,
        PuzzleTheme.defensiveMove,
        PuzzleTheme.deflection,
        PuzzleTheme.interference,
        PuzzleTheme.intermezzo,
        PuzzleTheme.quietMove,
        PuzzleTheme.xRayAttack,
        PuzzleTheme.zugzwang,
      ],
    ),
    Tuple2(
      l10n.mates,
      [
        PuzzleTheme.mate,
        PuzzleTheme.mateIn1,
        PuzzleTheme.mateIn2,
        PuzzleTheme.mateIn3,
        PuzzleTheme.mateIn4,
        PuzzleTheme.mateIn5,
        PuzzleTheme.anastasiaMate,
        PuzzleTheme.arabianMate,
        PuzzleTheme.backRankMate,
        PuzzleTheme.bodenMate,
        PuzzleTheme.doubleBishopMate,
        PuzzleTheme.dovetailMate,
        PuzzleTheme.hookMate,
        PuzzleTheme.smotheredMate,
      ],
    ),
    Tuple2(
      l10n.specialMoves,
      [
        PuzzleTheme.castling,
        PuzzleTheme.enPassant,
        PuzzleTheme.promotion,
        PuzzleTheme.underPromotion,
      ],
    ),
    Tuple2(
      l10n.goals,
      [
        PuzzleTheme.equality,
        PuzzleTheme.advantage,
        PuzzleTheme.crushing,
        PuzzleTheme.mate,
      ],
    ),
    Tuple2(
      l10n.lengths,
      [
        PuzzleTheme.oneMove,
        PuzzleTheme.long,
        PuzzleTheme.short,
        PuzzleTheme.veryLong,
      ],
    ),
    Tuple2(
      l10n.origin,
      [
        PuzzleTheme.master,
        PuzzleTheme.masterVsMaster,
        PuzzleTheme.superGM,
      ],
    ),
  ]);
}

class PuzzleThemeL10n {
  const PuzzleThemeL10n({required this.name, required this.description});
  final String name;
  final String description;
}

PuzzleThemeL10n puzzleThemeL10n(BuildContext context, PuzzleTheme theme) {
  switch (theme) {
    case PuzzleTheme.mix:
      return PuzzleThemeL10n(
        name: context.l10n.healthyMix,
        description: context.l10n.healthyMixDescription,
      );
    case PuzzleTheme.advancedPawn:
      return PuzzleThemeL10n(
        name: context.l10n.advancedPawn,
        description: context.l10n.advancedPawnDescription,
      );
    case PuzzleTheme.advantage:
      return PuzzleThemeL10n(
        name: context.l10n.advantage,
        description: context.l10n.advantageDescription,
      );
    case PuzzleTheme.anastasiaMate:
      return PuzzleThemeL10n(
        name: context.l10n.anastasiaMate,
        description: context.l10n.anastasiaMateDescription,
      );
    case PuzzleTheme.arabianMate:
      return PuzzleThemeL10n(
        name: context.l10n.arabianMate,
        description: context.l10n.arabianMateDescription,
      );
    case PuzzleTheme.attackingF2F7:
      return PuzzleThemeL10n(
        name: context.l10n.attackingF2F7,
        description: context.l10n.attackingF2F7Description,
      );
    case PuzzleTheme.attraction:
      return PuzzleThemeL10n(
        name: context.l10n.attraction,
        description: context.l10n.attractionDescription,
      );
    case PuzzleTheme.backRankMate:
      return PuzzleThemeL10n(
        name: context.l10n.backRankMate,
        description: context.l10n.backRankMateDescription,
      );
    case PuzzleTheme.bishopEndgame:
      return PuzzleThemeL10n(
        name: context.l10n.bishopEndgame,
        description: context.l10n.bishopEndgameDescription,
      );
    case PuzzleTheme.bodenMate:
      return PuzzleThemeL10n(
        name: context.l10n.bodenMate,
        description: context.l10n.bodenMateDescription,
      );
    case PuzzleTheme.capturingDefender:
      return PuzzleThemeL10n(
        name: context.l10n.capturingDefender,
        description: context.l10n.capturingDefenderDescription,
      );
    case PuzzleTheme.castling:
      return PuzzleThemeL10n(
        name: context.l10n.castling,
        description: context.l10n.castlingDescription,
      );
    case PuzzleTheme.clearance:
      return PuzzleThemeL10n(
        name: context.l10n.clearance,
        description: context.l10n.clearanceDescription,
      );
    case PuzzleTheme.crushing:
      return PuzzleThemeL10n(
        name: context.l10n.crushing,
        description: context.l10n.crushingDescription,
      );
    case PuzzleTheme.defensiveMove:
      return PuzzleThemeL10n(
        name: context.l10n.defensiveMove,
        description: context.l10n.defensiveMoveDescription,
      );
    case PuzzleTheme.deflection:
      return PuzzleThemeL10n(
        name: context.l10n.deflection,
        description: context.l10n.deflectionDescription,
      );
    case PuzzleTheme.discoveredAttack:
      return PuzzleThemeL10n(
        name: context.l10n.discoveredAttack,
        description: context.l10n.discoveredAttackDescription,
      );
    case PuzzleTheme.doubleBishopMate:
      return PuzzleThemeL10n(
        name: context.l10n.doubleBishopMate,
        description: context.l10n.doubleBishopMateDescription,
      );
    case PuzzleTheme.doubleCheck:
      return PuzzleThemeL10n(
        name: context.l10n.doubleCheck,
        description: context.l10n.doubleCheckDescription,
      );
    case PuzzleTheme.dovetailMate:
      return PuzzleThemeL10n(
        name: context.l10n.dovetailMate,
        description: context.l10n.dovetailMateDescription,
      );
    case PuzzleTheme.equality:
      return PuzzleThemeL10n(
        name: context.l10n.equality,
        description: context.l10n.equalityDescription,
      );
    case PuzzleTheme.endgame:
      return PuzzleThemeL10n(
        name: context.l10n.endgame,
        description: context.l10n.endgameDescription,
      );
    case PuzzleTheme.enPassant:
      return PuzzleThemeL10n(
        name: 'En passant',
        description: context.l10n.enPassantDescription,
      );
    case PuzzleTheme.exposedKing:
      return PuzzleThemeL10n(
        name: context.l10n.exposedKing,
        description: context.l10n.exposedKingDescription,
      );
    case PuzzleTheme.fork:
      return PuzzleThemeL10n(
        name: context.l10n.fork,
        description: context.l10n.forkDescription,
      );
    case PuzzleTheme.hangingPiece:
      return PuzzleThemeL10n(
        name: context.l10n.hangingPiece,
        description: context.l10n.hangingPieceDescription,
      );
    case PuzzleTheme.hookMate:
      return PuzzleThemeL10n(
        name: context.l10n.hookMate,
        description: context.l10n.hookMateDescription,
      );
    case PuzzleTheme.interference:
      return PuzzleThemeL10n(
        name: context.l10n.interference,
        description: context.l10n.interferenceDescription,
      );
    case PuzzleTheme.intermezzo:
      return PuzzleThemeL10n(
        name: context.l10n.intermezzo,
        description: context.l10n.intermezzoDescription,
      );
    case PuzzleTheme.kingsideAttack:
      return PuzzleThemeL10n(
        name: context.l10n.kingsideAttack,
        description: context.l10n.kingsideAttackDescription,
      );
    case PuzzleTheme.knightEndgame:
      return PuzzleThemeL10n(
        name: context.l10n.knightEndgame,
        description: context.l10n.knightEndgameDescription,
      );
    case PuzzleTheme.long:
      return PuzzleThemeL10n(
        name: context.l10n.long,
        description: context.l10n.longDescription,
      );
    case PuzzleTheme.master:
      return PuzzleThemeL10n(
        name: context.l10n.master,
        description: context.l10n.masterDescription,
      );
    case PuzzleTheme.masterVsMaster:
      return PuzzleThemeL10n(
        name: context.l10n.masterVsMaster,
        description: context.l10n.masterVsMasterDescription,
      );
    case PuzzleTheme.mate:
      return PuzzleThemeL10n(
        name: context.l10n.mate,
        description: context.l10n.mateDescription,
      );
    case PuzzleTheme.mateIn1:
      return PuzzleThemeL10n(
        name: context.l10n.mateIn1,
        description: context.l10n.mateIn1Description,
      );
    case PuzzleTheme.mateIn2:
      return PuzzleThemeL10n(
        name: context.l10n.mateIn2,
        description: context.l10n.mateIn2Description,
      );
    case PuzzleTheme.mateIn3:
      return PuzzleThemeL10n(
        name: context.l10n.mateIn3,
        description: context.l10n.mateIn3Description,
      );
    case PuzzleTheme.mateIn4:
      return PuzzleThemeL10n(
        name: context.l10n.mateIn4,
        description: context.l10n.mateIn4Description,
      );
    case PuzzleTheme.mateIn5:
      return PuzzleThemeL10n(
        name: context.l10n.mateIn5,
        description: context.l10n.mateIn5Description,
      );
    case PuzzleTheme.smotheredMate:
      return PuzzleThemeL10n(
        name: context.l10n.smotheredMate,
        description: context.l10n.smotheredMateDescription,
      );
    case PuzzleTheme.middlegame:
      return PuzzleThemeL10n(
        name: context.l10n.middlegame,
        description: context.l10n.middlegameDescription,
      );
    case PuzzleTheme.oneMove:
      return PuzzleThemeL10n(
        name: context.l10n.oneMove,
        description: context.l10n.oneMoveDescription,
      );
    case PuzzleTheme.opening:
      return PuzzleThemeL10n(
        name: context.l10n.opening,
        description: context.l10n.openingDescription,
      );
    case PuzzleTheme.pawnEndgame:
      return PuzzleThemeL10n(
        name: context.l10n.pawnEndgame,
        description: context.l10n.pawnEndgameDescription,
      );
    case PuzzleTheme.pin:
      return PuzzleThemeL10n(
        name: context.l10n.pin,
        description: context.l10n.pinDescription,
      );
    case PuzzleTheme.promotion:
      return PuzzleThemeL10n(
        name: context.l10n.promotion,
        description: context.l10n.promotionDescription,
      );
    case PuzzleTheme.queenEndgame:
      return PuzzleThemeL10n(
        name: context.l10n.queenEndgame,
        description: context.l10n.queenEndgameDescription,
      );
    case PuzzleTheme.queenRookEndgame:
      return PuzzleThemeL10n(
        name: context.l10n.queenRookEndgame,
        description: context.l10n.queenRookEndgameDescription,
      );
    case PuzzleTheme.queensideAttack:
      return PuzzleThemeL10n(
        name: context.l10n.queensideAttack,
        description: context.l10n.queensideAttackDescription,
      );
    case PuzzleTheme.quietMove:
      return PuzzleThemeL10n(
        name: context.l10n.quietMove,
        description: context.l10n.quietMoveDescription,
      );
    case PuzzleTheme.rookEndgame:
      return PuzzleThemeL10n(
        name: context.l10n.rookEndgame,
        description: context.l10n.rookEndgameDescription,
      );
    case PuzzleTheme.sacrifice:
      return PuzzleThemeL10n(
        name: context.l10n.sacrifice,
        description: context.l10n.sacrificeDescription,
      );
    case PuzzleTheme.short:
      return PuzzleThemeL10n(
        name: context.l10n.short,
        description: context.l10n.shortDescription,
      );
    case PuzzleTheme.skewer:
      return PuzzleThemeL10n(
        name: context.l10n.skewer,
        description: context.l10n.skewerDescription,
      );
    case PuzzleTheme.superGM:
      return PuzzleThemeL10n(
        name: context.l10n.superGM,
        description: context.l10n.superGMDescription,
      );
    case PuzzleTheme.trappedPiece:
      return PuzzleThemeL10n(
        name: context.l10n.trappedPiece,
        description: context.l10n.trappedPieceDescription,
      );
    case PuzzleTheme.underPromotion:
      return PuzzleThemeL10n(
        name: context.l10n.underPromotion,
        description: context.l10n.underPromotionDescription,
      );
    case PuzzleTheme.veryLong:
      return PuzzleThemeL10n(
        name: context.l10n.veryLong,
        description: context.l10n.veryLongDescription,
      );
    case PuzzleTheme.xRayAttack:
      return PuzzleThemeL10n(
        name: context.l10n.xRayAttack,
        description: context.l10n.xRayAttackDescription,
      );
    case PuzzleTheme.zugzwang:
      return PuzzleThemeL10n(
        name: context.l10n.zugzwang,
        description: context.l10n.zugzwangDescription,
      );
  }
}

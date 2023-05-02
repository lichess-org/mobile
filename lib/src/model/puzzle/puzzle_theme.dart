import 'package:flutter/widgets.dart';
import 'package:tuple/tuple.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Tuple2;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/utils/l10n.dart';
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
      l10n.strings.puzzleRecommended,
      [
        PuzzleTheme.mix,
      ],
    ),
    Tuple2(
      l10n.strings.puzzlePhases,
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
      l10n.strings.puzzleMotifs,
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
      l10n.strings.puzzleAdvanced,
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
      l10n.strings.puzzleMates,
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
      l10n.strings.puzzleSpecialMoves,
      [
        PuzzleTheme.castling,
        PuzzleTheme.enPassant,
        PuzzleTheme.promotion,
        PuzzleTheme.underPromotion,
      ],
    ),
    Tuple2(
      l10n.strings.puzzleGoals,
      [
        PuzzleTheme.equality,
        PuzzleTheme.advantage,
        PuzzleTheme.crushing,
        PuzzleTheme.mate,
      ],
    ),
    Tuple2(
      l10n.strings.puzzleLengths,
      [
        PuzzleTheme.oneMove,
        PuzzleTheme.long,
        PuzzleTheme.short,
        PuzzleTheme.veryLong,
      ],
    ),
    Tuple2(
      l10n.strings.puzzleOrigin,
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
        name: context.l10n.puzzleThemeHealthyMix,
        description: context.l10n.puzzleThemeHealthyMixDescription,
      );
    case PuzzleTheme.advancedPawn:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeAdvancedPawn,
        description: context.l10n.puzzleThemeAdvancedPawnDescription,
      );
    case PuzzleTheme.advantage:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeAdvantage,
        description: context.l10n.puzzleThemeAdvantageDescription,
      );
    case PuzzleTheme.anastasiaMate:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeAnastasiaMate,
        description: context.l10n.puzzleThemeAnastasiaMateDescription,
      );
    case PuzzleTheme.arabianMate:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeArabianMate,
        description: context.l10n.puzzleThemeArabianMateDescription,
      );
    case PuzzleTheme.attackingF2F7:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeAttackingF2F7,
        description: context.l10n.puzzleThemeAttackingF2F7Description,
      );
    case PuzzleTheme.attraction:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeAttraction,
        description: context.l10n.puzzleThemeAttractionDescription,
      );
    case PuzzleTheme.backRankMate:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeBackRankMate,
        description: context.l10n.puzzleThemeBackRankMateDescription,
      );
    case PuzzleTheme.bishopEndgame:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeBishopEndgame,
        description: context.l10n.puzzleThemeBishopEndgameDescription,
      );
    case PuzzleTheme.bodenMate:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeBodenMate,
        description: context.l10n.puzzleThemeBodenMateDescription,
      );
    case PuzzleTheme.capturingDefender:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeCapturingDefender,
        description: context.l10n.puzzleThemeCapturingDefenderDescription,
      );
    case PuzzleTheme.castling:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeCastling,
        description: context.l10n.puzzleThemeCastlingDescription,
      );
    case PuzzleTheme.clearance:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeClearance,
        description: context.l10n.puzzleThemeClearanceDescription,
      );
    case PuzzleTheme.crushing:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeCrushing,
        description: context.l10n.puzzleThemeCrushingDescription,
      );
    case PuzzleTheme.defensiveMove:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeDefensiveMove,
        description: context.l10n.puzzleThemeDefensiveMoveDescription,
      );
    case PuzzleTheme.deflection:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeDeflection,
        description: context.l10n.puzzleThemeDeflectionDescription,
      );
    case PuzzleTheme.discoveredAttack:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeDiscoveredAttack,
        description: context.l10n.puzzleThemeDiscoveredAttackDescription,
      );
    case PuzzleTheme.doubleBishopMate:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeDoubleBishopMate,
        description: context.l10n.puzzleThemeDoubleBishopMateDescription,
      );
    case PuzzleTheme.doubleCheck:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeDoubleCheck,
        description: context.l10n.puzzleThemeDoubleCheckDescription,
      );
    case PuzzleTheme.dovetailMate:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeDovetailMate,
        description: context.l10n.puzzleThemeDovetailMateDescription,
      );
    case PuzzleTheme.equality:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeEquality,
        description: context.l10n.puzzleThemeEqualityDescription,
      );
    case PuzzleTheme.endgame:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeEndgame,
        description: context.l10n.puzzleThemeEndgameDescription,
      );
    case PuzzleTheme.enPassant:
      return PuzzleThemeL10n(
        name: 'En passant',
        description: context.l10n.puzzleThemeEnPassantDescription,
      );
    case PuzzleTheme.exposedKing:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeExposedKing,
        description: context.l10n.puzzleThemeExposedKingDescription,
      );
    case PuzzleTheme.fork:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeFork,
        description: context.l10n.puzzleThemeForkDescription,
      );
    case PuzzleTheme.hangingPiece:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeHangingPiece,
        description: context.l10n.puzzleThemeHangingPieceDescription,
      );
    case PuzzleTheme.hookMate:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeHookMate,
        description: context.l10n.puzzleThemeHookMateDescription,
      );
    case PuzzleTheme.interference:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeInterference,
        description: context.l10n.puzzleThemeInterferenceDescription,
      );
    case PuzzleTheme.intermezzo:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeIntermezzo,
        description: context.l10n.puzzleThemeIntermezzoDescription,
      );
    case PuzzleTheme.kingsideAttack:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeKingsideAttack,
        description: context.l10n.puzzleThemeKingsideAttackDescription,
      );
    case PuzzleTheme.knightEndgame:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeKnightEndgame,
        description: context.l10n.puzzleThemeKnightEndgameDescription,
      );
    case PuzzleTheme.long:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeLong,
        description: context.l10n.puzzleThemeLongDescription,
      );
    case PuzzleTheme.master:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeMaster,
        description: context.l10n.puzzleThemeMasterDescription,
      );
    case PuzzleTheme.masterVsMaster:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeMasterVsMaster,
        description: context.l10n.puzzleThemeMasterVsMasterDescription,
      );
    case PuzzleTheme.mate:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeMate,
        description: context.l10n.puzzleThemeMateDescription,
      );
    case PuzzleTheme.mateIn1:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeMateIn1,
        description: context.l10n.puzzleThemeMateIn1Description,
      );
    case PuzzleTheme.mateIn2:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeMateIn2,
        description: context.l10n.puzzleThemeMateIn2Description,
      );
    case PuzzleTheme.mateIn3:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeMateIn3,
        description: context.l10n.puzzleThemeMateIn3Description,
      );
    case PuzzleTheme.mateIn4:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeMateIn4,
        description: context.l10n.puzzleThemeMateIn4Description,
      );
    case PuzzleTheme.mateIn5:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeMateIn5,
        description: context.l10n.puzzleThemeMateIn5Description,
      );
    case PuzzleTheme.smotheredMate:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeSmotheredMate,
        description: context.l10n.puzzleThemeSmotheredMateDescription,
      );
    case PuzzleTheme.middlegame:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeMiddlegame,
        description: context.l10n.puzzleThemeMiddlegameDescription,
      );
    case PuzzleTheme.oneMove:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeOneMove,
        description: context.l10n.puzzleThemeOneMoveDescription,
      );
    case PuzzleTheme.opening:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeOpening,
        description: context.l10n.puzzleThemeOpeningDescription,
      );
    case PuzzleTheme.pawnEndgame:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemePawnEndgame,
        description: context.l10n.puzzleThemePawnEndgameDescription,
      );
    case PuzzleTheme.pin:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemePin,
        description: context.l10n.puzzleThemePinDescription,
      );
    case PuzzleTheme.promotion:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemePromotion,
        description: context.l10n.puzzleThemePromotionDescription,
      );
    case PuzzleTheme.queenEndgame:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeQueenEndgame,
        description: context.l10n.puzzleThemeQueenEndgameDescription,
      );
    case PuzzleTheme.queenRookEndgame:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeQueenRookEndgame,
        description: context.l10n.puzzleThemeQueenRookEndgameDescription,
      );
    case PuzzleTheme.queensideAttack:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeQueensideAttack,
        description: context.l10n.puzzleThemeQueensideAttackDescription,
      );
    case PuzzleTheme.quietMove:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeQuietMove,
        description: context.l10n.puzzleThemeQuietMoveDescription,
      );
    case PuzzleTheme.rookEndgame:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeRookEndgame,
        description: context.l10n.puzzleThemeRookEndgameDescription,
      );
    case PuzzleTheme.sacrifice:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeSacrifice,
        description: context.l10n.puzzleThemeSacrificeDescription,
      );
    case PuzzleTheme.short:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeShort,
        description: context.l10n.puzzleThemeShortDescription,
      );
    case PuzzleTheme.skewer:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeSkewer,
        description: context.l10n.puzzleThemeSkewerDescription,
      );
    case PuzzleTheme.superGM:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeSuperGM,
        description: context.l10n.puzzleThemeSuperGMDescription,
      );
    case PuzzleTheme.trappedPiece:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeTrappedPiece,
        description: context.l10n.puzzleThemeTrappedPieceDescription,
      );
    case PuzzleTheme.underPromotion:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeUnderPromotion,
        description: context.l10n.puzzleThemeUnderPromotionDescription,
      );
    case PuzzleTheme.veryLong:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeVeryLong,
        description: context.l10n.puzzleThemeVeryLongDescription,
      );
    case PuzzleTheme.xRayAttack:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeXRayAttack,
        description: context.l10n.puzzleThemeXRayAttackDescription,
      );
    case PuzzleTheme.zugzwang:
      return PuzzleThemeL10n(
        name: context.l10n.puzzleThemeZugzwang,
        description: context.l10n.puzzleThemeZugzwangDescription,
      );
  }
}

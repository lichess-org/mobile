import 'package:flutter/widgets.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';

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

String puzzleThemeL10n(BuildContext context, PuzzleTheme theme) {
  switch (theme) {
    case PuzzleTheme.mix:
      return context.l10n.healthyMix;
    case PuzzleTheme.advancedPawn:
      return context.l10n.advancedPawn;
    case PuzzleTheme.advantage:
      return context.l10n.advantage;
    case PuzzleTheme.anastasiaMate:
      return context.l10n.anastasiaMate;
    case PuzzleTheme.arabianMate:
      return context.l10n.arabianMate;
    case PuzzleTheme.attackingF2F7:
      return context.l10n.attackingF2F7;
    case PuzzleTheme.attraction:
      return context.l10n.attraction;
    case PuzzleTheme.backRankMate:
      return context.l10n.backRankMate;
    case PuzzleTheme.bishopEndgame:
      return context.l10n.bishopEndgame;
    case PuzzleTheme.bodenMate:
      return context.l10n.bodenMate;
    case PuzzleTheme.capturingDefender:
      return context.l10n.capturingDefender;
    case PuzzleTheme.castling:
      return context.l10n.castling;
    case PuzzleTheme.clearance:
      return context.l10n.clearance;
    case PuzzleTheme.crushing:
      return context.l10n.crushing;
    case PuzzleTheme.defensiveMove:
      return context.l10n.defensiveMove;
    case PuzzleTheme.deflection:
      return context.l10n.deflection;
    case PuzzleTheme.discoveredAttack:
      return context.l10n.discoveredAttack;
    case PuzzleTheme.doubleBishopMate:
      return context.l10n.doubleBishopMate;
    case PuzzleTheme.doubleCheck:
      return context.l10n.doubleCheck;
    case PuzzleTheme.dovetailMate:
      return context.l10n.dovetailMate;
    case PuzzleTheme.equality:
      return context.l10n.equality;
    case PuzzleTheme.endgame:
      return context.l10n.endgame;
    case PuzzleTheme.enPassant:
      return 'En passant';
    case PuzzleTheme.exposedKing:
      return context.l10n.exposedKing;
    case PuzzleTheme.fork:
      return context.l10n.fork;
    case PuzzleTheme.hangingPiece:
      return context.l10n.hangingPiece;
    case PuzzleTheme.hookMate:
      return context.l10n.hookMate;
    case PuzzleTheme.interference:
      return context.l10n.interference;
    case PuzzleTheme.intermezzo:
      return context.l10n.intermezzo;
    case PuzzleTheme.kingsideAttack:
      return context.l10n.kingsideAttack;
    case PuzzleTheme.knightEndgame:
      return context.l10n.knightEndgame;
    case PuzzleTheme.long:
      return context.l10n.long;
    case PuzzleTheme.master:
      return context.l10n.master;
    case PuzzleTheme.masterVsMaster:
      return context.l10n.masterVsMaster;
    case PuzzleTheme.mate:
      return context.l10n.mate;
    case PuzzleTheme.mateIn1:
      return context.l10n.mateIn1;
    case PuzzleTheme.mateIn2:
      return context.l10n.mateIn2;
    case PuzzleTheme.mateIn3:
      return context.l10n.mateIn3;
    case PuzzleTheme.mateIn4:
      return context.l10n.mateIn4;
    case PuzzleTheme.mateIn5:
      return context.l10n.mateIn5;
    case PuzzleTheme.smotheredMate:
      return context.l10n.smotheredMate;
    case PuzzleTheme.middlegame:
      return context.l10n.middlegame;
    case PuzzleTheme.oneMove:
      return context.l10n.oneMove;
    case PuzzleTheme.opening:
      return context.l10n.opening;
    case PuzzleTheme.pawnEndgame:
      return context.l10n.pawnEndgame;
    case PuzzleTheme.pin:
      return context.l10n.pin;
    case PuzzleTheme.promotion:
      return context.l10n.promotion;
    case PuzzleTheme.queenEndgame:
      return context.l10n.queenEndgame;
    case PuzzleTheme.queenRookEndgame:
      return context.l10n.queenRookEndgame;
    case PuzzleTheme.queensideAttack:
      return context.l10n.queensideAttack;
    case PuzzleTheme.quietMove:
      return context.l10n.quietMove;
    case PuzzleTheme.rookEndgame:
      return context.l10n.rookEndgame;
    case PuzzleTheme.sacrifice:
      return context.l10n.sacrifice;
    case PuzzleTheme.short:
      return context.l10n.short;
    case PuzzleTheme.skewer:
      return context.l10n.skewer;
    case PuzzleTheme.superGM:
      return context.l10n.superGM;
    case PuzzleTheme.trappedPiece:
      return context.l10n.trappedPiece;
    case PuzzleTheme.underPromotion:
      return context.l10n.underPromotion;
    case PuzzleTheme.veryLong:
      return context.l10n.veryLong;
    case PuzzleTheme.xRayAttack:
      return context.l10n.xRayAttack;
    case PuzzleTheme.zugzwang:
      return context.l10n.zugzwang;
  }
}

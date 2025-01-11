import 'package:dartchess/dartchess.dart';
import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

String gameStatusL10n(
  BuildContext context, {
  required Variant variant,
  required GameStatus status,
  required Position lastPosition,
  Side? winner,
  bool? isThreefoldRepetition,
}) {
  switch (status) {
    case GameStatus.started:
      return context.l10n.playingRightNow;
    case GameStatus.aborted:
      return context.l10n.gameAborted;
    case GameStatus.mate:
      return context.l10n.checkmate;
    case GameStatus.resign:
      return winner == Side.black ? context.l10n.whiteResigned : context.l10n.blackResigned;
    case GameStatus.stalemate:
      return context.l10n.stalemate;
    case GameStatus.timeout:
      return winner == null
          ? lastPosition.turn == Side.white
              ? '${context.l10n.whiteLeftTheGame} • ${context.l10n.draw}'
              : '${context.l10n.blackLeftTheGame} • ${context.l10n.draw}'
          : winner == Side.black
          ? context.l10n.whiteLeftTheGame
          : context.l10n.blackLeftTheGame;
    case GameStatus.draw:
      if (lastPosition.isInsufficientMaterial) {
        return '${context.l10n.insufficientMaterial} • ${context.l10n.draw}';
      } else if (isThreefoldRepetition == true) {
        return '${context.l10n.threefoldRepetition} • ${context.l10n.draw}';
      } else {
        return context.l10n.draw;
      }
    case GameStatus.outoftime:
      return winner == null
          ? lastPosition.turn == Side.white
              ? '${context.l10n.whiteTimeOut} • ${context.l10n.draw}'
              : '${context.l10n.blackTimeOut} • ${context.l10n.draw}'
          : winner == Side.black
          ? context.l10n.whiteTimeOut
          : context.l10n.blackTimeOut;
    case GameStatus.noStart:
      return winner == Side.black ? context.l10n.whiteDidntMove : context.l10n.blackDidntMove;
    case GameStatus.unknownFinish:
      return context.l10n.finished;
    case GameStatus.cheat:
      return context.l10n.cheatDetected;
    case GameStatus.variantEnd:
      switch (variant) {
        case Variant.kingOfTheHill:
          return context.l10n.kingInTheCenter;
        case Variant.threeCheck:
          return context.l10n.threeChecks;
        default:
          return context.l10n.variantEnding;
      }
    default:
      return status.toString();
  }
}

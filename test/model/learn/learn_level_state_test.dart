import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/learn/learn_level.dart';
import 'package:lichess_mobile/src/model/learn/learn_level_state.dart';
import 'package:lichess_mobile/src/model/learn/learn_score.dart';
import 'package:lichess_mobile/src/model/learn/learn_stages.dart';

LearnLevel levelOf(String stageKey, int levelId) => learnStageByKey(stageKey)!.levels[levelId - 1];

NormalMove uci(String uci) => NormalMove.fromUci(uci);

void main() {
  group('apple levels', () {
    test('apples are enemy pawns, and collecting them scores', () {
      final state = LearnLevelState.initial(levelOf('rook', 2));
      expect(state.position.board.pieceAt(Square.c5), Piece.blackPawn);
      expect(state.displayFen, '8/2R5/8/8/8/8/8/8');

      final first = state.playerMove(uci('c7c5'));
      expect(first.state.apples, ISet(const [Square.g5]));
      expect(first.state.score, kLearnAppleScore);
      expect(first.sounds, [Sound.learnTake]);
      expect(first.state.isPlayerTurn, isTrue, reason: 'the turn goes back to the player');
      expect(first.state.shapes, isEmpty);

      final second = first.state.playerMove(uci('c5g5'));
      expect(second.state.completed, isTrue);
      expect(second.state.score, 2 * kLearnAppleScore + 500);
      expect(learnLevelRank(second.state.level, second.state.score), 1);
    });

    test('finishing over par gives a lower bonus', () {
      var state = LearnLevelState.initial(levelOf('rook', 1));
      state = state.playerMove(uci('e2e3')).state;
      state = state.playerMove(uci('e3e7')).state;
      expect(state.completed, isTrue);
      expect(state.score, kLearnAppleScore + 300);
      expect(learnLevelRank(state.level, state.score), 2);
    });

    test('king apples are empty squares', () {
      final state = LearnLevelState.initial(levelOf('king', 1));
      expect(state.position.board.pieceAt(Square.e6), isNull);
    });

    test('failure predicate', () {
      // The pawn must not stay on e3: it should use the double step.
      final result = LearnLevelState.initial(levelOf('pawn', 7)).playerMove(uci('e2e3'));
      expect(result.state.failed, isTrue);
      expect(result.sounds, [Sound.learnFailure, Sound.move]);
    });
  });

  group('captures', () {
    test('hanging a piece fails, and the opponent takes it', () {
      final result = LearnLevelState.initial(levelOf('capture', 2)).playerMove(uci('f4f7'));
      expect(result.state.failed, isTrue);
      expect(result.state.threatSquare, Square.c7);
      expect(result.followUp, LearnFollowUp.opponentCapture);

      final after = result.state.opponentCapture();
      expect(after.position.board.pieceAt(Square.f7), Piece.blackRook);
      expect(after.lastMove, uci('c7f7'));
    });

    test('a protected capture is allowed', () {
      var state = LearnLevelState.initial(levelOf('capture', 2));
      final first = state.playerMove(uci('f4c7'));
      expect(first.state.failed, isFalse);
      expect(first.state.score, kLearnCaptureScore);
      state = first.state.playerMove(uci('c7f7')).state;
      expect(state.completed, isTrue);
    });

    test('piece values', () {
      final result = LearnLevelState.initial(levelOf('value', 1)).playerMove(uci('d5c6'));
      expect(result.state.completed, isTrue);
      expect(result.state.score, learnPieceValue(Role.queen) + kLearnScenarioScore + 500);
    });
  });

  group('check', () {
    test('moving into check fails and shows the attackers', () {
      final result = LearnLevelState.initial(levelOf('outOfCheck', 1)).playerMove(uci('e1e2'));
      expect(result.state.failed, isTrue);
      expect(result.state.checkSquare, Square.e2);
      expect(result.state.shapes, [
        const LearnShape(orig: Square.e5, dest: Square.e2, brush: .red),
      ]);
      expect(result.sounds, [Sound.learnFailure]);
    });

    test('illegal moves are offered only when the level says so', () {
      final offered = LearnLevelState.initial(levelOf('outOfCheck', 1));
      expect(offered.playerDests[Square.e1], contains(Square.e2));

      final notOffered = LearnLevelState.initial(
        LearnLevel.parse(goal: (l) => '', fen: '8/8/8/4q3/8/8/8/4K3 w - -', nbMoves: 1),
      );
      expect(notOffered.playerDests[Square.e1], isNot(contains(Square.e2)));
    });

    test('giving check shows the checking arrows', () {
      final result = LearnLevelState.initial(levelOf('check1', 1)).playerMove(uci('a1e1'));
      expect(result.state.completed, isTrue);
      expect(result.state.checkSquare, Square.e8);
    });

    test('checkmate follow-up after a failure', () {
      final result = LearnLevelState.initial(levelOf('checkmate1', 1)).playerMove(uci('f3f4'));
      expect(result.state.failed, isTrue);
      expect(result.followUp, LearnFollowUp.randomOpponentMove);
      final after = result.state.randomOpponentMove(Random(0));
      expect(after.position.turn, Side.white);
      expect(after.lastMove, isNotNull);
    });
  });

  group('castling', () {
    test('castling with the king two squares succeeds', () {
      final state = LearnLevelState.initial(levelOf('castling', 1));
      expect(state.playerDests[Square.e1], containsAll([Square.g1, Square.h1]));
      final result = state.playerMove(uci('e1g1'));
      expect(result.state.completed, isTrue);
      expect(result.state.lastMove, uci('e1g1'));
    });

    test('castling onto the rook succeeds', () {
      final result = LearnLevelState.initial(levelOf('castling', 1)).playerMove(uci('e1h1'));
      expect(result.state.completed, isTrue);
      expect(result.state.lastMove, uci('e1g1'));
    });

    test('losing the right to castle fails', () {
      final result = LearnLevelState.initial(levelOf('castling', 1)).playerMove(uci('h1g1'));
      expect(result.state.failed, isTrue);
    });
  });

  group('scenario', () {
    test('the opponent moves first in en passant levels', () {
      final state = LearnLevelState.initial(levelOf('enpassant', 1));
      expect(state.isPlayerTurn, isFalse);
      expect(state.isOpponentScenarioTurn, isTrue);

      final afterOpponent = state.opponentScenarioMove();
      expect(afterOpponent.isPlayerTurn, isTrue);
      expect(afterOpponent.shapes, [
        const LearnShape(orig: Square.c5, dest: Square.d6, brush: .paleGreen),
      ]);

      final result = afterOpponent.playerMove(uci('c5d6'));
      expect(result.state.completed, isTrue);
      expect(result.state.position.board.pieceAt(Square.d5), isNull);
    });

    test('deviating from the scenario fails', () {
      final result = LearnLevelState.initial(levelOf('enpassant', 1))
          .opponentScenarioMove()
          .playerMove(uci('c5c6'));
      expect(result.state.failed, isTrue);
      expect(result.state.scenarioFailed, isTrue);
    });

    test('the next scripted opponent move is requested', () {
      final state = LearnLevelState.initial(levelOf('enpassant', 4)).opponentScenarioMove();
      final result = state.playerMove(uci('c5b6'));
      expect(result.state.failed, isFalse);
      expect(result.followUp, LearnFollowUp.opponentScenarioMove);
      expect(result.state.opponentScenarioMove().lastMove, uci('f7f5'));
    });
  });

  test('stage rank', () {
    final stage = learnStageByKey('rook')!;
    final perfect = stage.levels.map((l) => l.apples.length * kLearnAppleScore + 500).toIList();
    expect(learnStageRank(stage, perfect), 1);
    expect(learnStageRank(stage, perfect.map((s) => s - 100).toIList()), 2);
    expect(learnStageRank(stage, const IListConst([100])), 3);
  });
}

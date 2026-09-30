import 'dart:collection';
import 'dart:io' as io;

import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/learn/learn_level_state.dart';
import 'package:lichess_mobile/src/model/learn/learn_stages.dart';

/// Searches for a sequence of player moves that completes the level within its par.
///
/// Breadth-first over distinct states, playing the scripted opponent moves as they come. Returns
/// null if the level cannot be completed in [maxMoves] moves.
List<NormalMove>? solve(LearnLevelState initial, {required int maxMoves}) {
  final queue = Queue<(LearnLevelState, List<NormalMove>)>()..add((initial, const []));
  final seen = <String>{};
  while (queue.isNotEmpty) {
    final (state, moves) = queue.removeFirst();
    if (moves.length >= maxMoves) continue;
    for (final entry in state.playerDests.entries) {
      for (final to in entry.value) {
        final move = NormalMove(from: entry.key, to: to);
        final isPromotion =
            state.position.board.pawns.has(move.from) && SquareSet.backranks.has(to);
        final candidates = isPromotion
            ? [Role.queen, Role.rook, Role.bishop, Role.knight].map(move.withPromotion)
            : [move];
        for (final candidate in candidates) {
          final result = state.playerMove(candidate);
          var next = result.state;
          final path = [...moves, candidate];
          if (next.completed) return path;
          if (next.failed) continue;
          if (result.followUp == LearnFollowUp.opponentScenarioMove) {
            next = next.opponentScenarioMove();
          }
          final key =
              '${next.position.boardFen} ${next.position.turn} ${next.apples} '
              '${next.scenarioIndex} ${next.position.castles.castlingRights}';
          if (seen.add(key)) queue.add((next, path));
        }
      }
    }
  }
  return null;
}

void main() {
  test('there are 18 stages and 110 levels', () {
    expect(learnStages.length, 18);
    expect(learnStages.fold(0, (sum, s) => sum + s.levels.length), 110);
    expect(learnStages.map((s) => s.key).toSet().length, 18);
  });

  test('every stage image is bundled', () {
    for (final stage in learnStages) {
      final path = 'assets/images/learn/${stage.image}.webp';
      expect(io.File(path).existsSync(), isTrue, reason: path);
    }
  });

  for (final stage in learnStages) {
    group('stage ${stage.key}', () {
      for (final (index, level) in stage.levels.indexed) {
        final name = 'level ${index + 1}';

        test('$name data is consistent', () {
          final pos = level.position;
          for (final apple in level.apples) {
            expect(pos.board.pieceAt(apple), isNull, reason: 'apple on occupied $apple');
          }
          if (level.scenario.isEmpty) {
            expect(level.color, pos.turn, reason: 'color differs from the side to move');
          }
          var state = LearnLevelState.initial(level);
          while (!state.scenarioComplete && !state.isOver) {
            final step = level.scenario[state.scenarioIndex];
            if (state.isOpponentScenarioTurn) {
              expect(
                state.position.destsOf(step.move.from).has(step.move.to),
                isTrue,
                reason: 'opponent scenario move ${step.uci} is illegal',
              );
              state = state.opponentScenarioMove();
            } else {
              expect(
                state.playerDests[step.move.from]?.contains(step.move.to),
                isTrue,
                reason: 'player scenario move ${step.uci} is illegal',
              );
              state = state.playerMove(step.move).state;
            }
          }
          if (level.scenario.isNotEmpty) {
            expect(state.completed, isTrue, reason: 'playing the scenario does not complete');
            expect(state.failed, isFalse);
          }
        });

        test('$name can be completed within par', () {
          final initial = LearnLevelState.initial(level);
          if (initial.isOpponentScenarioTurn) {
            // The level starts with the opponent's scripted move.
            final solution = solve(initial.opponentScenarioMove(), maxMoves: level.nbMoves);
            expect(solution, isNotNull);
          } else {
            final solution = solve(initial, maxMoves: level.nbMoves);
            expect(solution, isNotNull);
          }
        });
      }
    });
  }
}

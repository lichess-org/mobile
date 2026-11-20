import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/engine/practice_analyser.dart';
import 'package:lichess_mobile/src/model/engine/practice_comment.dart';
import 'package:lichess_mobile/src/model/practice/practice_goal.dart';

Position _position(String fen) => Chess.fromSetup(Setup.parseFen(fen));

/// A position with the game still going, Black to move.
final _ongoing = _position('8/8/3k4/8/8/4K3/8/Q6R b - - 0 1');

/// Black is checkmated.
final _blackMated = _position('k7/1Q6/1K6/8/8/8/8/8 b - - 0 1');

/// White is checkmated.
final _whiteMated = _position('8/8/8/8/8/1k6/1q6/K7 w - - 0 1');

/// Black is stalemated.
final _stalemate = _position('k7/2Q5/1K6/8/8/8/8/8 b - - 0 1');

/// Kings only.
final _deadDraw = _position('8/8/8/4k3/8/8/8/4K3 b - - 0 1');

final _move = Move.parse('a1a2')!;
final _promotion = Move.parse('a7a8q')!;

LocalEval _eval({int? cp, int? mate, int depth = kPracticeUsableDepth}) => LocalEval(
  position: _ongoing,
  searchTime: const Duration(seconds: 1),
  cp: cp,
  mate: mate,
  depth: depth,
  nodes: 1000,
  millis: 1000,
  pvs: const IListConst([]),
  threatMode: false,
);

/// A shallower eval than [PracticeGoal.judge] relies on.
LocalEval _shallow({int? cp, int? mate}) =>
    _eval(cp: cp, mate: mate, depth: kPracticeUsableDepth - 1);

PracticeStatus _judge(
  PracticeGoal goal, {
  Side playerSide = Side.white,
  Position? position,
  Move? lastMove,
  bool noMove = false,
  ClientEval? eval,
  MoveVerdict? verdict,
  int nbMoves = 1,
  bool threefold = false,
}) => goal.judge(
  playerSide: playerSide,
  position: position ?? _ongoing,
  lastMove: noMove ? null : lastMove ?? _move,
  eval: eval,
  verdict: verdict,
  nbMoves: nbMoves,
  threefold: threefold,
);

void main() {
  group('PracticeGoal.fromPick', () {
    PracticeGoal parse(Map<String, dynamic> json) => PracticeGoal.fromPick(pick(json).required());

    test('parses every goal shape', () {
      expect(parse({'result': 'mate'}), const PracticeGoal.mate());
      expect(parse({'result': 'mateIn', 'moves': 3}), const PracticeGoal.mateIn(moves: 3));
      expect(parse({'result': 'drawIn', 'moves': 20}), const PracticeGoal.drawIn(moves: 20));
      expect(parse({'result': 'equalIn', 'moves': 2}), const PracticeGoal.equalIn(moves: 2));
      expect(
        parse({'result': 'evalIn', 'cp': -400, 'moves': 3}),
        const PracticeGoal.evalIn(cp: -400, moves: 3),
      );
      expect(parse({'result': 'promotion', 'cp': 100}), const PracticeGoal.promotion(cp: 100));
    });

    test('rejects an unknown goal or a missing field', () {
      expect(() => parse({'result': 'stalemate'}), throwsA(isA<PickException>()));
      expect(() => parse({'result': 'mateIn'}), throwsA(isA<PickException>()));
    });
  });

  group('judge, any goal', () {
    const goal = PracticeGoal.drawIn(moves: 10);

    test('is ongoing before the first move', () {
      expect(
        _judge(goal, noMove: true, position: _blackMated, eval: _eval(cp: 900)),
        PracticeStatus.ongoing,
      );
    });

    test('is decided by a checkmate, whatever the goal', () {
      expect(_judge(goal, position: _blackMated), PracticeStatus.solved);
      expect(_judge(goal, position: _whiteMated), PracticeStatus.failed);
      expect(
        _judge(const PracticeGoal.mate(), playerSide: Side.black, position: _blackMated),
        PracticeStatus.failed,
      );
    });

    test('fails on a mistake or a blunder only', () {
      const mate = PracticeGoal.mate();
      final winning = _eval(cp: 900);
      expect(_judge(mate, eval: winning, verdict: .mistake), PracticeStatus.failed);
      expect(_judge(mate, eval: winning, verdict: .blunder), PracticeStatus.failed);
      expect(_judge(mate, eval: winning, verdict: .inaccuracy), PracticeStatus.ongoing);
      expect(_judge(mate, eval: winning, verdict: .notBest), PracticeStatus.ongoing);
      expect(_judge(mate, eval: winning, verdict: .goodMove), PracticeStatus.ongoing);
    });

    test('ignores an eval that is not deep enough', () {
      const mate = PracticeGoal.mate();
      expect(_judge(mate, eval: _eval(cp: 0)), PracticeStatus.failed);
      expect(_judge(mate, eval: _shallow(cp: 0)), PracticeStatus.ongoing);
    });
  });

  for (final goal in const [PracticeGoal.drawIn(moves: 5), PracticeGoal.equalIn(moves: 5)]) {
    group('judge, $goal', () {
      test('is solved by a threefold repetition', () {
        expect(_judge(goal, eval: _eval(cp: 500), threefold: true), PracticeStatus.solved);
      });

      test('fails as soon as the position is not drawish', () {
        expect(_judge(goal, eval: _eval(cp: 150)), PracticeStatus.failed);
        expect(_judge(goal, eval: _eval(cp: -300)), PracticeStatus.failed);
        expect(_judge(goal, eval: _eval(mate: 3)), PracticeStatus.failed);
        expect(_judge(goal, eval: _shallow(cp: 300)), PracticeStatus.ongoing);
      });

      test('fails past the move budget', () {
        expect(_judge(goal, nbMoves: 6, eval: _eval(cp: 0)), PracticeStatus.failed);
      });

      test('is solved by a drawn game over', () {
        expect(_judge(goal, position: _stalemate, nbMoves: 2), PracticeStatus.solved);
        expect(_judge(goal, position: _deadDraw, nbMoves: 2), PracticeStatus.solved);
      });

      test('at the move budget, is solved if the position is drawish', () {
        expect(_judge(goal, nbMoves: 5, eval: _eval(cp: 50)), PracticeStatus.solved);
        expect(_judge(goal, nbMoves: 5, eval: _shallow(cp: 50)), PracticeStatus.ongoing);
      });

      test('is ongoing before the move budget', () {
        expect(_judge(goal, nbMoves: 3, eval: _eval(cp: 50)), PracticeStatus.ongoing);
      });
    });
  }

  group('judge, evalIn', () {
    const white = PracticeGoal.evalIn(cp: 400, moves: 2);

    test('is not judged before the move budget', () {
      expect(_judge(white, nbMoves: 1, eval: _eval(cp: -900)), PracticeStatus.ongoing);
    });

    test('at the move budget, compares the eval with the goal', () {
      expect(_judge(white, nbMoves: 2, eval: _eval(cp: 400)), PracticeStatus.solved);
      expect(_judge(white, nbMoves: 3, eval: _eval(cp: 450)), PracticeStatus.solved);
      expect(_judge(white, nbMoves: 2, eval: _eval(cp: 300)), PracticeStatus.failed);
      expect(_judge(white, nbMoves: 2, eval: _eval(mate: 4)), PracticeStatus.solved);
      expect(_judge(white, nbMoves: 2, eval: _eval(mate: -2)), PracticeStatus.failed);
      expect(_judge(white, nbMoves: 2, eval: _shallow(cp: 900)), PracticeStatus.ongoing);
    });

    test('a stalemate or a dead draw fails without an eval', () {
      expect(_judge(white, nbMoves: 2, position: _stalemate), PracticeStatus.failed);
      expect(_judge(white, nbMoves: 2, position: _deadDraw), PracticeStatus.failed);
    });

    test('the goal is from White point of view', () {
      const black = PracticeGoal.evalIn(cp: -400, moves: 2);
      PracticeStatus asBlack(ClientEval eval) =>
          _judge(black, playerSide: Side.black, nbMoves: 2, eval: eval);
      expect(asBlack(_eval(cp: -500)), PracticeStatus.solved);
      expect(asBlack(_eval(cp: -100)), PracticeStatus.failed);
      expect(asBlack(_eval(mate: -3)), PracticeStatus.solved);
    });
  });

  group('judge, mateIn', () {
    const goal = PracticeGoal.mateIn(moves: 3);

    test('fails past the move budget', () {
      expect(_judge(goal, nbMoves: 4, eval: _eval(mate: 1)), PracticeStatus.failed);
    });

    test('needs a solid eval to judge', () {
      expect(_judge(goal, eval: _shallow(cp: 0)), PracticeStatus.ongoing);
      expect(_judge(goal), PracticeStatus.ongoing);
    });

    test('fails when the mate no longer fits in the budget', () {
      expect(_judge(goal, nbMoves: 1, eval: _eval(mate: 2)), PracticeStatus.ongoing);
      expect(_judge(goal, nbMoves: 1, eval: _eval(mate: 3)), PracticeStatus.failed);
    });

    test('fails when there is no mate for the player', () {
      expect(_judge(goal, eval: _eval(cp: 900)), PracticeStatus.failed);
      expect(_judge(goal, eval: _eval(mate: -2)), PracticeStatus.failed);
    });

    test('reads the mate from the player point of view', () {
      expect(_judge(goal, playerSide: Side.black, eval: _eval(mate: -2)), PracticeStatus.ongoing);
      expect(_judge(goal, playerSide: Side.black, eval: _eval(mate: 2)), PracticeStatus.failed);
    });
  });

  group('judge, promotion', () {
    const goal = PracticeGoal.promotion(cp: 100);

    test('is only judged on a promotion', () {
      expect(_judge(goal, eval: _eval(cp: -900)), PracticeStatus.ongoing);
    });

    test('on a promotion, compares the eval with the goal', () {
      expect(_judge(goal, lastMove: _promotion, eval: _eval(cp: 500)), PracticeStatus.solved);
      expect(_judge(goal, lastMove: _promotion, eval: _eval(cp: 0)), PracticeStatus.failed);
      expect(_judge(goal, lastMove: _promotion, eval: _shallow(cp: 500)), PracticeStatus.ongoing);
    });
  });

  group('judge, mate', () {
    const goal = PracticeGoal.mate();

    test('fails on a threefold repetition, a drawish eval or a stalemate', () {
      expect(_judge(goal, threefold: true), PracticeStatus.failed);
      expect(_judge(goal, eval: _eval(cp: 100)), PracticeStatus.failed);
      expect(_judge(goal, position: _stalemate), PracticeStatus.failed);
    });

    test('is ongoing while winning', () {
      expect(_judge(goal, eval: _eval(cp: 900)), PracticeStatus.ongoing);
      expect(_judge(goal, eval: _eval(mate: 12)), PracticeStatus.ongoing);
    });
  });
}

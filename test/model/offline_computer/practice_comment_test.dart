import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/offline_computer/practice_comment.dart';

void main() {
  group('MoveVerdict', () {
    test('has correct thresholds', () {
      // Good move: shift < kGoodMoveThreshold (0.04)
      expect(
        MoveVerdict.fromShift(
          0.03,
          hasBetterMove: true,
          winningChancesBefore: 0.0,
          winningChancesAfter: -0.03,
        ),
        MoveVerdict.goodMove,
      );
      expect(
        MoveVerdict.fromShift(
          0.039,
          hasBetterMove: true,
          winningChancesBefore: 0.0,
          winningChancesAfter: -0.039,
        ),
        MoveVerdict.goodMove,
      );

      // Inaccuracy: kGoodMoveThreshold <= shift < kInaccuracyThreshold (in non-winning position)
      expect(
        MoveVerdict.fromShift(
          0.04,
          hasBetterMove: true,
          winningChancesBefore: 0.3,
          winningChancesAfter: 0.26,
        ),
        MoveVerdict.inaccuracy,
      );
      expect(
        MoveVerdict.fromShift(
          0.07,
          hasBetterMove: true,
          winningChancesBefore: 0.3,
          winningChancesAfter: 0.23,
        ),
        MoveVerdict.inaccuracy,
      );

      // Mistake: kInaccuracyThreshold <= shift < kMistakeThreshold (in non-winning position)
      expect(
        MoveVerdict.fromShift(
          0.08,
          hasBetterMove: true,
          winningChancesBefore: 0.3,
          winningChancesAfter: 0.22,
        ),
        MoveVerdict.mistake,
      );
      expect(
        MoveVerdict.fromShift(
          0.15,
          hasBetterMove: true,
          winningChancesBefore: 0.3,
          winningChancesAfter: 0.15,
        ),
        MoveVerdict.mistake,
      );

      // Blunder: shift >= kMistakeThreshold (in non-winning position)
      expect(
        MoveVerdict.fromShift(
          0.18,
          hasBetterMove: true,
          winningChancesBefore: 0.3,
          winningChancesAfter: 0.12,
        ),
        MoveVerdict.blunder,
      );
      expect(
        MoveVerdict.fromShift(
          0.5,
          hasBetterMove: true,
          winningChancesBefore: 0.4,
          winningChancesAfter: -0.1,
        ),
        MoveVerdict.blunder,
      );

      // If no better move, always good
      expect(
        MoveVerdict.fromShift(
          0.5,
          hasBetterMove: false,
          winningChancesBefore: 0.5,
          winningChancesAfter: 0.0,
        ),
        MoveVerdict.goodMove,
      );

      // notBest: suboptimal move that keeps a winning position
      expect(
        MoveVerdict.fromShift(
          0.1,
          hasBetterMove: true,
          winningChancesBefore: 0.8,
          winningChancesAfter: 0.7,
        ),
        MoveVerdict.notBest,
      );
      expect(
        MoveVerdict.fromShift(
          0.3,
          hasBetterMove: true,
          winningChancesBefore: 0.9,
          winningChancesAfter: 0.6,
        ),
        MoveVerdict.notBest,
      );

      // Not notBest if position drops below winning threshold
      expect(
        MoveVerdict.fromShift(
          0.2,
          hasBetterMove: true,
          winningChancesBefore: 0.6,
          winningChancesAfter: 0.4,
        ),
        MoveVerdict.blunder,
      );
    });

    test('has correct icons', () {
      expect(MoveVerdict.goodMove.icon, Icons.check_circle);
      expect(MoveVerdict.notBest.icon, Icons.info);
      expect(MoveVerdict.inaccuracy.icon, Icons.help);
      expect(MoveVerdict.mistake.icon, Icons.error);
      expect(MoveVerdict.blunder.icon, Icons.cancel);
    });
  });

  group('PracticeComment', () {
    test('uses book icon for book moves', () {
      const comment = PracticeComment(
        verdict: MoveVerdict.goodMove,
        winningChancesBefore: 0.5,
        winningChancesAfter: 0.5,
        isBookMove: true,
      );
      expect(comment.icon, Icons.menu_book);

      const normalComment = PracticeComment(
        verdict: MoveVerdict.goodMove,
        winningChancesBefore: 0.5,
        winningChancesAfter: 0.5,
        isBookMove: false,
      );
      expect(normalComment.icon, Icons.check_circle);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/offline_computer/practice_comment.dart';

void main() {
  group('MoveVerdict', () {
    test('has correct thresholds', () {
      // Good move: shift < 0.025
      expect(
        MoveVerdict.fromShift(
          0.02,
          hasBetterMove: true,
          winningChancesBefore: 0.0,
          winningChancesAfter: -0.02,
        ),
        MoveVerdict.goodMove,
      );
      expect(
        MoveVerdict.fromShift(
          0.024,
          hasBetterMove: true,
          winningChancesBefore: 0.0,
          winningChancesAfter: -0.024,
        ),
        MoveVerdict.goodMove,
      );

      // Inaccuracy: 0.025 <= shift < 0.06 (in non-winning position)
      expect(
        MoveVerdict.fromShift(
          0.025,
          hasBetterMove: true,
          winningChancesBefore: 0.3,
          winningChancesAfter: 0.275,
        ),
        MoveVerdict.inaccuracy,
      );
      expect(
        MoveVerdict.fromShift(
          0.05,
          hasBetterMove: true,
          winningChancesBefore: 0.3,
          winningChancesAfter: 0.25,
        ),
        MoveVerdict.inaccuracy,
      );

      // Mistake: 0.06 <= shift < 0.14 (in non-winning position)
      expect(
        MoveVerdict.fromShift(
          0.06,
          hasBetterMove: true,
          winningChancesBefore: 0.3,
          winningChancesAfter: 0.24,
        ),
        MoveVerdict.mistake,
      );
      expect(
        MoveVerdict.fromShift(
          0.1,
          hasBetterMove: true,
          winningChancesBefore: 0.3,
          winningChancesAfter: 0.2,
        ),
        MoveVerdict.mistake,
      );

      // Blunder: shift >= 0.14 (in non-winning position)
      expect(
        MoveVerdict.fromShift(
          0.14,
          hasBetterMove: true,
          winningChancesBefore: 0.3,
          winningChancesAfter: 0.16,
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

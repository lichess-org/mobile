import 'dart:math' as math;

import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/thinking_time.dart';

/// After 1. e4 e5 2. Nf3 Nc6 3. Bb5 a6 4. Ba4 Nf6 5. O-O Be7 6. Bxc6.
///
/// Black to move at ply 11 — past the opening window — with 25 legal moves, no check, and a
/// recapture available on c6. One position that can be asked for both a reflex and a quiet move,
/// so that the only thing differing between the two is the move itself.
final afterBxc6 = [
  'e2e4',
  'e7e5',
  'g1f3',
  'b8c6',
  'f1b5',
  'a7a6',
  'b5a4',
  'g8f6',
  'e1g1',
  'f8e7',
  'a4c6',
].fold<Position>(Chess.initial, (position, uci) => position.play(Move.parse(uci)!));

/// Black is in check from Ra8 and has exactly one legal answer, Rb8.
final onlyMove = Chess.fromSetup(Setup.parseFen('R6k/6pp/8/8/8/7K/8/1r6 b - - 0 1'));

/// Many draws for one position, from a fresh stream each time.
///
/// Reseeding matters: two samples compared against each other have to see the *same* random draws,
/// so that the difference between them is the position and the move and nothing else.
List<Duration> sample({
  required Position position,
  required String move,
  String? lastMove,
  int seed = 1,
  int count = 400,
}) {
  final thinkingTime = ThinkingTime(random: math.Random(seed));
  return List.generate(
    count,
    (_) => thinkingTime.forMove(
      position: position,
      move: Move.parse(move)!,
      lastMove: lastMove != null ? Move.parse(lastMove) : null,
    ),
  );
}

Duration median(List<Duration> durations) {
  final sorted = List<Duration>.of(durations)..sort();
  return sorted[sorted.length ~/ 2];
}

void main() {
  group('ThinkingTime', () {
    test('never waits longer than the cap, or less than the floor', () {
      // Every kind of position, not just the comfortable ones: the cap is a promise to the user,
      // and the floor is what keeps a reflex from being no wait at all.
      final all = [
        ...sample(position: Chess.initial, move: 'e2e4'),
        ...sample(position: afterBxc6, move: 'd7c6', lastMove: 'a4c6'),
        ...sample(position: afterBxc6, move: 'h7h6'),
        ...sample(position: onlyMove, move: 'b1b8'),
      ];

      expect(all.every((d) => d <= const Duration(seconds: 3)), isTrue);
      expect(all.every((d) => d >= const Duration(milliseconds: 250)), isTrue);
    });

    test('an ordinary position takes about a second', () {
      final times = sample(position: afterBxc6, move: 'h7h6');

      expect(median(times), greaterThan(const Duration(milliseconds: 600)));
      expect(median(times), lessThan(const Duration(milliseconds: 1800)));
    });

    test('the spread is wide and skewed, not a flat range', () {
      final times = sample(position: afterBxc6, move: 'h7h6', count: 2000)..sort();

      final p10 = times[200];
      final p50 = times[1000];
      final p90 = times[1800];

      // A log-normal keeps its body below the mean and its tail above it, so the climb from the
      // median to p90 is longer than the climb from p10 to the median. A uniform range — the
      // obvious wrong implementation — would make the two roughly equal.
      expect(p90 - p50, greaterThan(p50 - p10));
    });

    test('a recapture comes back much faster than a quiet move', () {
      // 6...dxc6 takes straight back on the square the bishop just landed on; 6...h6 is the same
      // position, the same draws, and a move that is not a reflex.
      final recapture = median(sample(position: afterBxc6, move: 'd7c6', lastMove: 'a4c6'));
      final quiet = median(sample(position: afterBxc6, move: 'h7h6', lastMove: 'a4c6'));

      expect(recapture, lessThan(quiet ~/ 2));
    });

    test('a move that lands somewhere else is not a recapture', () {
      final afterCapture = median(sample(position: afterBxc6, move: 'h7h6', lastMove: 'a4c6'));
      final afterQuietMove = median(sample(position: afterBxc6, move: 'h7h6', lastMove: 'e1g1'));

      // The opponent having just captured is not what makes it a reflex; taking the piece back is.
      expect(afterCapture, afterQuietMove);
    });

    test('opening moves come out of memory', () {
      final opening = median(sample(position: Chess.initial, move: 'e2e4'));
      final middlegame = median(sample(position: afterBxc6, move: 'h7h6'));

      expect(opening, lessThan(middlegame));
    });

    test('a forced reply is played at once', () {
      final times = sample(position: onlyMove, move: 'b1b8', lastMove: 'a1a8')..sort();

      // There is nothing to decide, so the usual reply is the floor. Not *every* one: the draw
      // still has a tail, and a player taking a second to check that the only move really is the
      // only move is human enough to be worth keeping.
      expect(median(times), const Duration(milliseconds: 250));
      expect(times[times.length * 9 ~/ 10], lessThan(const Duration(milliseconds: 500)));
      expect(times, everyElement(lessThan(const Duration(milliseconds: 1200))));
    });

    test('instant never waits at all', () {
      const thinkingTime = ThinkingTime.instant();

      expect(thinkingTime.forMove(position: afterBxc6, move: Move.parse('h7h6')!), Duration.zero);
    });
  });
}

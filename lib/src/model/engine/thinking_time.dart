import 'dart:math' as math;

import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The longest the opponent will ever appear to think.
///
/// Well short of a real human, who regularly spends ten seconds on a move and occasionally a
/// minute. This is deliberately stylised rather than faithful: an offline game has no clock and no
/// opponent waiting, so a truthful think is just an app that makes you sit and watch nothing
/// happen.
const _kMaxThinkingTime = Duration(seconds: 3);

/// The shortest, which is not zero: even a move already decided on takes a moment to reach for.
const _kMinThinkingTime = Duration(milliseconds: 250);

/// The median for an ordinary middlegame position, before the position scales it.
const _kMedianThinkingTime = Duration(milliseconds: 1100);

/// The spread of the log-normal the time is drawn from.
///
/// Human move times are strongly right-skewed — a short, dense body with a long tail of real
/// thinks — which is what a log-normal gives and a uniform range does not. At 0.6, about two
/// thirds of moves land within a factor of 1.8 either side of the median.
const _kSigma = 0.6;

/// The only legal move is not a decision.
const _kForcedFactor = 0.15;

/// Taking back the piece that just took yours is a reflex.
const _kRecaptureFactor = 0.3;

/// A king in check has few answers, and they are easy to see.
const _kInCheckFactor = 0.5;

/// Opening moves come out of memory rather than calculation.
const _kOpeningFactor = 0.4;
const _kOpeningPlies = 8;

/// Roughly what an unremarkable middlegame position offers, for scaling the branching factor.
const _kTypicalLegalMoves = 30;

/// How long the computer should appear to think before playing the move it has already chosen.
///
/// Maia answers in a few tens of milliseconds — it is one forward pass through a small network at
/// a single node — so without this its move appears the instant you finish yours, which is the
/// most obviously inhuman thing about playing it. Note what this is not: it is not a search limit,
/// and it does not change which move is played. The move is known before this is consulted.
class ThinkingTime {
  ThinkingTime({math.Random? random}) : _random = random ?? math.Random();

  /// Never waits.
  ///
  /// What tests use, so that a suite that plays a few hundred moves does not take a few hundred
  /// seconds.
  const ThinkingTime.instant() : _random = null;

  final math.Random? _random;

  /// How long to sit on [move] before playing it in [position].
  ///
  /// [position] is the one the opponent is moving from, and [lastMove] the move that led to it.
  Duration forMove({required Position position, required Move move, Move? lastMove}) {
    final random = _random;
    if (random == null) return Duration.zero;

    final median = _kMedianThinkingTime.inMilliseconds * _difficulty(position, move, lastMove);
    final sampled = median * math.exp(_kSigma * _gaussian(random));

    return Duration(
      milliseconds: sampled
          .clamp(
            _kMinThinkingTime.inMilliseconds.toDouble(),
            _kMaxThinkingTime.inMilliseconds.toDouble(),
          )
          .round(),
    );
  }

  /// How much longer or shorter than an ordinary position this one is worth thinking about.
  ///
  /// Everything here is something a player reacts to before they have thought at all: there is only
  /// one move, or the piece that just landed can be taken back, or the king is in check, or the
  /// game has not left the opening. It is deliberately not an assessment of the position — that
  /// would want the policy distribution Maia is not asked for at one node.
  double _difficulty(Position position, Move move, Move? lastMove) {
    final legalMoves = position.legalMoves.values.fold(0, (count, to) => count + to.size);
    if (legalMoves <= 1) return _kForcedFactor;

    var factor = 1.0;

    // A capture on the square the opponent just moved to, which is a recapture or near enough:
    // either way it is the piece that just appeared being taken straight back.
    if (lastMove != null && move.to == lastMove.to && position.board.pieceAt(move.to) != null) {
      factor *= _kRecaptureFactor;
    }
    if (position.isCheck) factor *= _kInCheckFactor;
    if (position.ply < _kOpeningPlies) factor *= _kOpeningFactor;

    // Mildly, because a wide position is not necessarily a hard one — but a narrow one is rarely a
    // hard one.
    return factor * math.sqrt(legalMoves / _kTypicalLegalMoves).clamp(0.6, 1.3);
  }

  /// One draw from a standard normal, by the Box–Muller transform.
  double _gaussian(math.Random random) {
    // Shifted off zero because `nextDouble` returns [0, 1) and log(0) is negative infinity.
    final u = 1.0 - random.nextDouble();
    final v = random.nextDouble();
    return math.sqrt(-2.0 * math.log(u)) * math.cos(2.0 * math.pi * v);
  }
}

/// How long the computer opponent appears to think.
///
/// Overridden with [ThinkingTime.instant] in tests, where the waits would be real seconds.
final thinkingTimeProvider = Provider<ThinkingTime>(
  (ref) => ThinkingTime(),
  name: 'ThinkingTimeProvider',
);

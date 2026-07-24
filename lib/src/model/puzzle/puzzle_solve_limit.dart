import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

/// How long the app backs off from submitting solves after the server answers a
/// solve batch with 429 Too Many Requests.
///
/// The puzzle solve rate limit is a rolling window on the server, so this fixed
/// duration is a heuristic: if a flush attempted after it expires is limited
/// again, the back-off simply re-arms itself.
const kPuzzleSolveLimitDuration = Duration(hours: 1);

/// The last time the server rate-limited solve submissions, and how many pending
/// solves were rejected then. `null` when the limit has never been hit.
typedef PuzzleSolveLimit = ({DateTime since, int solvedCount});

/// Tracks whether the server is currently rate-limiting puzzle solve
/// submissions (HTTP 429), so the sync path can stop hammering it and the UI can
/// tell the user to wait.
///
/// Global, not per-angle: the solve rate limit is account-wide, so hitting it on
/// one angle means every angle is limited. In-memory only: after a restart the
/// first flush re-hits the limit and re-arms this, so persistence buys little.
class PuzzleSolveLimiter extends Notifier<PuzzleSolveLimit?> {
  @override
  PuzzleSolveLimit? build() => null;

  /// Whether solve submissions are currently backed off.
  bool get isLimited {
    final current = state;
    return current != null && DateTime.now().isBefore(current.since.add(kPuzzleSolveLimitDuration));
  }

  /// Records that the server rejected a flush of [solvedCount] pending solves.
  void markLimited(int solvedCount) {
    state = (since: DateTime.now(), solvedCount: solvedCount);
  }

  /// Like [markLimited] but with an explicit timestamp, to simulate an expired
  /// back-off in tests.
  @visibleForTesting
  void markLimitedAt(DateTime since, int solvedCount) {
    state = (since: since, solvedCount: solvedCount);
  }
}

final puzzleSolveLimiterProvider = NotifierProvider<PuzzleSolveLimiter, PuzzleSolveLimit?>(
  PuzzleSolveLimiter.new,
  name: 'PuzzleSolveLimiterProvider',
);

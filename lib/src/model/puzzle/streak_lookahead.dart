import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_streak.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:logging/logging.dart';

final _logger = Logger('StreakLookahead');

/// How many puzzles one refill fetches, in a single `/api/puzzle/many` request.
const _windowSize = 30;

/// Refill once fewer than this many puzzles are cached past the one being played.
const _margin = 10;

/// How many advances to wait before retrying a refill that failed.
const _retryAfter = 5;

/// Keeps the puzzles of one streak run cached ahead of the one being played, so that the run goes
/// on offline.
///
/// Refills are best-effort: the streak loads each puzzle on its own when it is due, so a failed
/// refill only costs the offline play. One instance serves one run.
class StreakLookahead {
  StreakLookahead(this.run, {required this.storage, required this.repository})
    : assert(_windowSize <= kServerPuzzleManyCap);

  final Streak run;
  final PuzzleStorage storage;
  final PuzzleRepository repository;

  /// Exclusive end of the range of [run] known to be cached.
  int _cachedUpTo = 0;

  /// Refills for an index before this one are skipped: the back-off after a failed refill.
  int _retryFrom = 0;

  bool _refilling = false;

  /// Caches the next [_windowSize] puzzles once fewer than [_margin] are cached past [index], the
  /// one being played. Never throws.
  Future<void> refill(int index) async {
    final from = index + 1;
    if (_refilling || from < _retryFrom || _cachedUpTo >= from + _margin) return;
    // Start past what is cached, so that the windows do not overlap.
    final start = max(from, _cachedUpTo);
    final to = min(start + _windowSize, run.length);
    if (start >= to) return;

    _refilling = true;
    try {
      final window = run.sublist(start, to);
      final cached = await storage.cachedPuzzleIds(ids: window);
      final missing = window.where((id) => !cached.contains(id)).toIList();
      if (missing.isNotEmpty) {
        await storage.saveAll(puzzles: await repository.fetchMany(missing));
      }
      // The whole window counts as cached, even if the server dropped an id: the streak fetches
      // such a puzzle on its own and fails the same way, so asking again is pointless.
      _cachedUpTo = max(_cachedUpTo, to);
    } catch (e) {
      // A 429 means the hourly puzzle budget is spent, and any other 4xx is final: stop asking
      // for this run. Play goes on from `/api/puzzle/{id}`, which is not rate limited.
      final refused = e is ServerException && e.statusCode < 500;
      _retryFrom = refused ? run.length : from + _retryAfter;
      _logger.info('Streak look-ahead refill failed', e);
    } finally {
      _refilling = false;
    }
  }
}

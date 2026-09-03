import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_streak.dart';
import 'package:lichess_mobile/src/model/puzzle/streak_lookahead.dart';
import 'package:lichess_mobile/src/model/puzzle/streak_score_sync.dart';
import 'package:lichess_mobile/src/model/puzzle/streak_storage.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:logging/logging.dart';

final _logger = Logger('PuzzleStreakController');

/// [PuzzleStreak] with its current [Puzzle].
typedef StreakState = ({PuzzleStreak streak, Puzzle puzzle});

/// Outcome of [PuzzleStreakController.next].
enum StreakAdvance {
  advanced,

  /// The next puzzle could not be loaded (e.g. offline with nothing cached). The streak stays on
  /// the solved puzzle and moves on by itself once back online.
  unavailable,

  /// The streak has no puzzle left, moved on or was disposed while the next puzzle was loading.
  aborted,

  /// The server refuses the next puzzle for good, so the run ended here, with the solve counted.
  ended,
}

final puzzleStreakControllerProvider =
    AsyncNotifierProvider.autoDispose<PuzzleStreakController, StreakState>(
      PuzzleStreakController.new,
      name: 'PuzzleStreakControllerProvider',
    );

/// Plays a streak run from the local puzzle cache, so that it goes on offline.
///
/// Puzzles are loaded cache-first through [PuzzleService.loadPuzzle], and a [StreakLookahead]
/// keeps the coming ones cached. A solve whose next puzzle cannot be loaded is kept as
/// [PuzzleStreak.advancePending] and completed on reconnect; a run that ends offline queues its
/// score for [StreakScoreSync] to post.
class PuzzleStreakController extends AsyncNotifier<StreakState> {
  late StreakStorage _storage;
  UserId? _userId;
  late StreakLookahead _lookahead;

  /// The run being played, or null while a new one is loading or the last load failed.
  StreakState? get _current => switch (state) {
    AsyncData(:final value, isLoading: false) => value,
    _ => null,
  };

  Future<PuzzleService> get _service => ref.read(puzzleServiceProvider.future);

  @override
  Future<StreakState> build() async {
    _userId = ref.watch(authControllerProvider)?.user.id;
    _storage = ref.watch(streakStorageProvider(_userId));

    ref.read(streakScoreSyncProvider).flush(_userId).ignore();

    ref.listen(connectivityChangesProvider, (previous, now) {
      if (previous?.value?.isOnline != false || now.value?.isOnline != true) return;
      if (state is AsyncError) {
        // A load that failed offline, e.g. a solve stranded with nothing cached.
        ref.invalidateSelf();
      } else if (_current?.streak.advancePending ?? false) {
        // A solve stranded offline. Should this fail too, the screen offers a retry.
        next().ignore();
      }
    });

    final saved = await _storage.loadActiveStreak();
    if (saved == null) return _newRun();

    // A solve stranded offline counts, and is never replayed.
    final active = saved.copyWith(index: saved.score, advancePending: false);
    final Puzzle puzzle;
    try {
      puzzle = await (await _service).loadPuzzle(active.streak[active.index]);
    } catch (e) {
      if (!isPermanentFailure(e)) rethrow;
      // The server will never serve this puzzle: end the run with the score it has, rather than
      // failing on every visit until the user gives up on the feature.
      _logger.warning('Ending a streak whose puzzle the server refuses', e);
      await _endRun(active.score);
      return _newRun();
    }
    if (active != saved) await _storage.saveActiveStreak(active);
    return _start(active, puzzle);
  }

  Future<StreakState> _newRun() async {
    final response = await ref.read(puzzleRepositoryProvider).streak();
    final streak = PuzzleStreak(
      streak: response.streak,
      index: 0,
      hasSkipped: false,
      finished: false,
      timestamp: response.timestamp,
    );
    // The first puzzle comes embedded in the response; the others are loaded by id.
    await ((await _service).cachePuzzle(response.puzzle), _storage.saveActiveStreak(streak)).wait;
    return _start(streak, response.puzzle);
  }

  Future<StreakState> _start(PuzzleStreak streak, Puzzle puzzle) async {
    _lookahead = StreakLookahead(
      streak.streak,
      storage: await ref.read(puzzleStorageProvider.future),
      repository: ref.read(puzzleRepositoryProvider),
    );
    _lookahead.refill(streak.index).ignore();
    return (streak: streak, puzzle: puzzle);
  }

  /// The run being played if it is still on the solve at [index] of [run], or null once the
  /// notifier was disposed, a new run started or another advance went through.
  StreakState? _sameSolve(Streak run, int index) {
    if (!ref.mounted) return null;
    final current = _current;
    if (current == null || current.streak.streak != run || current.streak.index != index) {
      return null;
    }
    return current;
  }

  void skipMove() {
    final current = _current;
    if (current == null) return;
    final skipped = current.streak.copyWith(hasSkipped: true);
    state = AsyncData((streak: skipped, puzzle: current.puzzle));
    _storage.saveActiveStreak(skipped);
  }

  /// Advances the streak to the next puzzle. Offline with nothing cached, the streak stays on the
  /// solved puzzle with [PuzzleStreak.advancePending] set, and completes the advance on reconnect.
  Future<StreakAdvance> next() async {
    var solved = _current;
    if (solved == null) return .aborted;
    final nextId = solved.streak.nextId;
    if (nextId == null) return .aborted;
    final run = solved.streak.streak;
    final index = solved.streak.index;

    if (!solved.streak.advancePending) {
      // The solve counts from now on: cut short (screen left, app killed) or failed, the run
      // resumes on the next puzzle rather than replaying this one.
      final pending = solved.streak.copyWith(advancePending: true);
      state = AsyncData((streak: pending, puzzle: solved.puzzle));
      await _storage.saveActiveStreak(pending);
    }

    Puzzle? puzzle;
    try {
      puzzle = await (await _service).loadPuzzle(nextId);
    } catch (e) {
      if (isPermanentFailure(e)) {
        // The server will never serve it, so the run ends here, with the solve counted.
        _logger.warning('Ending a streak whose next puzzle the server refuses', e);
        solved = _sameSolve(run, index);
        if (solved == null) return .aborted;
        await _finish(solved);
        return .ended;
      }
      _logger.info('Could not load puzzle $nextId', e);
    }
    solved = _sameSolve(run, index);
    if (solved == null) return .aborted;
    if (puzzle == null) return .unavailable;

    ref.read(soundServiceProvider).play(Sound.confirmation);
    final advanced = solved.streak.copyWith(index: index + 1, advancePending: false);
    state = AsyncData((streak: advanced, puzzle: puzzle));
    _lookahead.refill(advanced.index).ignore();
    await _storage.saveActiveStreak(advanced);
    return .advanced;
  }

  Future<void> gameOver() async {
    final current = _current;
    if (current == null || current.streak.finished) return;
    await _finish(current);
  }

  Future<void> _finish(StreakState current) async {
    final finished = current.streak.copyWith(finished: true);
    state = AsyncData((streak: finished, puzzle: current.puzzle));
    await _endRun(finished.score);
  }

  /// Clears the run and posts [score], queued first so that a post that fails now is retried
  /// later. Reads what it needs up front, as the screen may be left (disposing the notifier)
  /// during the awaits.
  Future<void> _endRun(int score) async {
    final storage = _storage;
    final userId = _userId;
    final scoreSync = ref.read(streakScoreSyncProvider);
    final posting = userId != null && score > 0;
    // Issued together: both hit the preferences cache synchronously, so a 'New streak' tap during
    // the disk writes cannot load the run back.
    await Future.wait([if (posting) storage.savePendingScore(score), storage.clearActiveStreak()]);
    if (posting) await scoreSync.flush(userId);
  }
}

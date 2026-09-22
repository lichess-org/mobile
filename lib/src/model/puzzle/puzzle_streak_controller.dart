import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_streak.dart';
import 'package:lichess_mobile/src/model/puzzle/streak_storage.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:logging/logging.dart';

final _logger = Logger('PuzzleStreakController');

/// [PuzzleStreak] with its current [Puzzle].
typedef StreakState = ({PuzzleStreak streak, Puzzle puzzle});

final puzzleStreakControllerProvider =
    AsyncNotifierProvider.autoDispose<PuzzleStreakController, StreakState>(
      PuzzleStreakController.new,
      name: 'PuzzleStreakControllerProvider',
    );

/// Plays a streak run from the local puzzle storage, which is kept filled ahead of the current
/// puzzle so that the run goes on offline.
class PuzzleStreakController() extends AsyncNotifier<StreakState> {
  /// How many of the coming puzzles are fetched at once (the server serves 50 at most).
  static const prefetchSize = 50;

  /// Fetch the coming puzzles once one of the next [prefetchMargin] is not stored.
  static const prefetchMargin = 10;

  late StreakStorage _storage;
  UserId? _userId;
  bool _isPrefetching = false;
  bool _prefetchRefused = false;
  Future<void>? _ending;

  @override
  Future<StreakState> build() async {
    _userId = ref.watch(authControllerProvider)?.user.id;
    _storage = ref.watch(streakStorageProvider(_userId));

    final saved = await _storage.loadActiveStreak();
    final StreakState current;
    if (saved != null && !saved.finished) {
      current = (streak: saved, puzzle: await loadPuzzle(saved.streak[saved.index]));
    } else {
      // A run that ended while offline is kept until its score is posted.
      if (saved != null) await _endRun(saved);
      final response = await ref.read(puzzleRepositoryProvider).streak();
      final storage = await ref.read(puzzleStorageProvider.future);
      await storage.save(puzzle: response.puzzle);
      current = (
        streak: PuzzleStreak(
          streak: response.streak,
          index: 0,
          hasSkipped: false,
          finished: false,
          timestamp: response.timestamp,
        ),
        puzzle: response.puzzle,
      );
    }
    unawaited(_prefetch(current.streak));
    return current;
  }

  /// Loads a puzzle from the local storage, or from the server if it is not stored.
  Future<Puzzle> loadPuzzle(PuzzleId id) async {
    final repository = ref.read(puzzleRepositoryProvider);
    final storage = await ref.read(puzzleStorageProvider.future);
    final stored = await storage.fetch(puzzleId: id);
    if (stored != null) return stored;
    final puzzle = await repository.fetch(id);
    await storage.save(puzzle: puzzle);
    return puzzle;
  }

  void skipMove() {
    final current = state.value;
    if (current == null) return;
    final streak = current.streak.copyWith(hasSkipped: true);
    state = AsyncData((streak: streak, puzzle: current.puzzle));
    _storage.saveActiveStreak(streak);
  }

  /// Advances the streak to the next puzzle.
  ///
  /// The solve is saved first, so that it counts even if the next puzzle cannot be loaded (offline
  /// and not stored). The streak then shows the error, and resumes on the next load.
  Future<void> next() async {
    final current = state.value;
    final nextId = current?.streak.nextId;
    if (current == null || nextId == null) return;

    final streak = current.streak.copyWith(index: current.streak.index + 1);
    await _storage.saveActiveStreak(streak);
    try {
      final puzzle = await loadPuzzle(nextId);
      if (!ref.mounted) return;
      ref.read(soundServiceProvider).play(Sound.confirmation);
      state = AsyncData((streak: streak, puzzle: puzzle));
      unawaited(_prefetch(streak));
    } catch (e, st) {
      if (ref.mounted) state = AsyncError(e, st);
    }
  }

  Future<void> gameOver() {
    final current = state.value;
    if (current == null || current.streak.finished) return Future.value();
    final streak = current.streak.copyWith(finished: true);
    state = AsyncData((streak: streak, puzzle: current.puzzle));
    return _ending = _endRun(streak);
  }

  /// Starts a new run, once the score of the last one has been posted.
  Future<void> newStreak() async {
    await _ending;
    if (ref.mounted) ref.invalidateSelf();
  }

  /// Posts the score of a finished run and clears it.
  ///
  /// The run is saved as finished first, so that if the score cannot be posted now (e.g. offline),
  /// it is posted when the next run is loaded.
  Future<void> _endRun(PuzzleStreak streak) async {
    final repository = ref.read(puzzleRepositoryProvider);
    final storage = _storage;
    await storage.saveActiveStreak(streak);
    if (_userId != null && streak.index > 0) {
      try {
        await repository.postStreakRun(streak.index);
      } catch (e) {
        _logger.info('Could not post the streak score, will retry on the next run', e);
        return;
      }
    }
    await storage.clearActiveStreak();
  }

  /// Stores the coming puzzles of the run, so that it goes on offline.
  ///
  /// Waits until one of the next [prefetchMargin] puzzles is missing, then fetches all the missing
  /// ones among the next [prefetchSize] in a single request. Best-effort: a puzzle that is not
  /// stored is fetched on its own when it is due.
  Future<void> _prefetch(PuzzleStreak streak) async {
    if (_isPrefetching || _prefetchRefused) return;
    _isPrefetching = true;
    try {
      final repository = ref.read(puzzleRepositoryProvider);
      final storage = await ref.read(puzzleStorageProvider.future);
      final coming = streak.streak.skip(streak.index + 1).take(prefetchSize).toIList();
      final missing = await storage.missingIds(coming);
      if (coming.take(prefetchMargin).any(missing.contains)) {
        await storage.saveAll(await repository.fetchMany(missing));
      }
    } catch (e) {
      _logger.info('Could not prefetch the streak puzzles', e);
      // Retry a network error on the next puzzle, but not a refusal (e.g. rate limited).
      if (e is ServerException) _prefetchRefused = true;
    } finally {
      _isPrefetching = false;
    }
  }
}

import 'dart:math' show max;

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_batch_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_preferences.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

/// The server caps each batch request at 50 puzzles regardless of the requested
/// `nb` (`nb.atMost(50)` in lila's `Puzzle` controller), so a queue larger than
/// this is filled with several sequential requests, each asking for the current
/// deficit and receiving at most 50.

/// Whether a one-time offline-queue fill is currently running.
///
/// This is a top-level (stable) provider, not per-[PuzzleService] state, so the
/// single-flight guard actually holds: the puzzle service factory builds a fresh
/// service on every read, but this notifier is a single instance.
final puzzleQueueFillerProvider = NotifierProvider<PuzzleQueueFiller, bool>(
  PuzzleQueueFiller.new,
  name: 'PuzzleQueueFillerProvider',
);

class PuzzleQueueFiller extends Notifier<bool> {
  final Logger _log = Logger('PuzzleQueueFiller');

  @override
  bool build() => false;

  /// Fills the offline queue for [angle] up to the configured
  /// `nbOfflinePuzzles`, one server batch at a time.
  ///
  /// This is a one-time, select-only action triggered when the offline puzzle
  /// count or the difficulty changes. It never submits solves, so it can't race
  /// with the solve/sync path over the stored `solved` list. Re-reads storage
  /// *after* each network request and merges by puzzle id, so a solve made
  /// while a request is in flight is never clobbered. Guarded by [state] so
  /// overlapping calls can't double-fetch. No-op for anonymous users: the
  /// configurable queue length is a logged-in-only feature. Never throws:
  /// network and storage failures stop the fill.
  Future<void> fill({
    required UserId? userId,
    PuzzleAngle angle = const PuzzleTheme(PuzzleThemeKey.mix),
    @visibleForTesting int? queueLengthOverride,
  }) async {
    // The larger offline queue is a logged-in-only feature: anonymous players
    // face a much higher server rate limit for fetching puzzles, so the fill is
    // a no-op for them.
    if (userId == null) return;
    if (state) return;
    state = true;
    try {
      final queueLength =
          queueLengthOverride ?? ref.read(puzzlePreferencesProvider).nbOfflinePuzzles;
      final difficulty = ref.read(puzzlePreferencesProvider).difficulty;
      final batchStorage = await ref.read(puzzleBatchStorageProvider.future);

      // Tracks the stored queue length across passes. Stop when a pass fails to
      // grow the queue (server exhausted or a silent no-op write), not when it
      // shrinks: a solve made mid-fill lowers the count and legitimately widens
      // the deficit, so that pass should still top up.
      int lastLength = -1;
      while (true) {
        final PuzzleBatch? current;
        try {
          current = await batchStorage.fetch(userId: userId, angle: angle);
        } catch (e, st) {
          // Corrupted prefs, decode error, or sqflite failure: stop the fill.
          _log.warning('Offline puzzle queue fill: storage read failed', e, st);
          break;
        }
        final unsolved = current?.unsolved ?? IList(const []);

        if (unsolved.length == lastLength) break;
        lastLength = unsolved.length;

        final deficit = max(0, queueLength - unsolved.length);
        if (deficit <= 0) break;

        final PuzzleBatchResponse response;
        try {
          response = await ref.withClient(
            (client) => PuzzleRepository(
              client,
            ).selectBatch(nb: deficit, angle: angle, difficulty: difficulty),
          );
        } catch (e, st) {
          // Offline or server error: stop the fill, keep what we have.
          _log.warning('Offline puzzle queue fill failed', e, st);
          break;
        }

        // Server has no more puzzles: stop rather than spin forever below an
        // unreachable `queueLength`.
        if (response.puzzles.isEmpty) break;

        // Re-read storage AFTER the network round-trip: a solve made while the
        // request was in flight moves a puzzle unsolved->solved on this same
        // row. Merging into the pre-request snapshot would restore it to
        // unsolved and drop its solution. Merge into the fresh read instead.
        try {
          final fresh = await batchStorage.fetch(userId: userId, angle: angle);
          final freshUnsolved = fresh?.unsolved ?? IList(const []);

          // Skip ids already stored (in the fresh read) so a re-read after a
          // mid-fill solve can't reintroduce a duplicate.
          final existingIds = freshUnsolved.map((p) => p.puzzle.id).toISet();
          final additions = response.puzzles.where((p) => !existingIds.contains(p.puzzle.id));
          if (additions.isEmpty) break;

          await batchStorage.save(
            userId: userId,
            angle: angle,
            data: PuzzleBatch(
              solved: fresh?.solved ?? IList(const []),
              unsolved: IList([...freshUnsolved, ...additions]),
            ),
          );
        } catch (e, st) {
          // sqflite I/O or serialization failure on the merge read/write:
          // stop the fill rather than surface an unhandled async error.
          _log.warning('Offline puzzle queue fill: storage write failed', e, st);
          break;
        }
      }
    } finally {
      state = false;
    }
  }
}

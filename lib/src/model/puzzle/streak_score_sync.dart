import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/streak_storage.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:logging/logging.dart';

final _logger = Logger('StreakScoreSync');

final streakScoreSyncProvider = Provider<StreakScoreSync>(
  StreakScoreSync.new,
  name: 'StreakScoreSyncProvider',
);

/// Posts the pending streak score of a user: a run that ended but could not be posted yet.
///
/// Lives outside the streak controller, which is disposed with its screen, so that a score can be
/// posted on reconnect or on the next app start.
class StreakScoreSync {
  StreakScoreSync(this._ref);

  final Ref _ref;

  /// The last flush per user. A new one queues behind it, as the running one may have loaded the
  /// pending score before it was updated.
  final Map<UserId, Future<void>> _flushes = {};

  /// Posts the pending score of the signed-in user, if any.
  Future<void> flushCurrentUser() => flush(_ref.read(authControllerProvider)?.user.id);

  /// Posts [userId]'s pending score, if any. A failure worth retrying leaves it for the next
  /// attempt; one the server has rejected for good drops it.
  Future<void> flush(UserId? userId) {
    if (userId == null) return Future.value();
    return _flushes[userId] = (_flushes[userId] ?? Future.value()).then((_) => _flush(userId));
  }

  Future<void> _flush(UserId userId) async {
    try {
      final storage = _ref.read(streakStorageProvider(userId));
      final pending = await storage.loadPendingScore();
      if (pending == null) return;
      try {
        await _ref.read(puzzleRepositoryProvider).postStreakRun(pending);
      } catch (e) {
        if (!isPermanentFailure(e)) {
          _logger.info('Could not post the pending streak score', e);
          return;
        }
        _logger.warning('Dropping a streak score the server rejected', e);
      }
      await storage.clearPendingScoreIfAtMost(pending);
    } catch (e) {
      _logger.info('Could not flush the pending streak score', e);
    }
  }
}

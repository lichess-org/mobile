import 'package:lichess_mobile/src/network/http.dart';

/// Server sync of the learn progress, mirroring `ui/learn/src/storage.ts` on lichess.org.
///
/// Only meaningful for logged-in users: lila answers both endpoints with an authentication
/// error otherwise. Callers must check the auth state first and swallow network errors, so
/// that syncing never breaks completing a level while offline.
class LearnRepository(final LichessClient _client) {
  /// Saves [score] for the 1-based level [levelId] of [stageKey].
  ///
  /// Throws a [ServerException] if the response doesn't have a success status code.
  Future<void> saveScore({required String stageKey, required int levelId, required int score}) {
    return _client.postRead(
      Uri(path: '/learn/score'),
      body: {'stage': stageKey, 'level': '$levelId', 'score': '$score'},
    );
  }

  /// Resets the server-side learn progress.
  ///
  /// Throws a [ServerException] if the response doesn't have a success status code.
  Future<void> reset() {
    return _client.postRead(Uri(path: '/learn/reset'));
  }
}

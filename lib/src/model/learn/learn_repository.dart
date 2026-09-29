import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/network/http.dart';

/// The learn progress on the server, mirroring `ui/learn/src/storage.ts` on lichess.org.
///
/// Only for logged-in users: lila rejects both endpoints otherwise. Callers check the auth state
/// and swallow network errors, so syncing never breaks completing a level while offline.
class LearnRepository(final LichessClient _client) {
  /// Saves [score] for the 1-based level [levelId] of [stageKey].
  ///
  /// The server overwrites unconditionally, so only send an improvement.
  ///
  /// Throws a [ServerException] if the response is not a success.
  Future<void> saveScore({required String stageKey, required int levelId, required int score}) {
    return _client.postRead(
      Uri(path: '/learn/score'),
      body: {'stage': stageKey, 'level': '$levelId', 'score': '$score'},
    );
  }

  /// Wipes the server-side learn progress.
  ///
  /// Throws a [ServerException] if the response is not a success.
  Future<void> reset() {
    return _client.postRead(Uri(path: '/learn/reset'));
  }

  /// The best score of each level the server knows, per stage.
  ///
  /// A stage's list is indexed by level and can be shorter than its number of levels, so an
  /// absent index means no score yet.
  ///
  /// Throws a [ServerException] if the response is not a success.
  Future<IMap<String, IMap<int, int>>> fetchProgress() {
    return _client.readJson(
      Uri(path: '/api/learn/progress'),
      mapper: (json) {
        final stages = json['stages'];
        if (stages is! Map) return const IMapConst({});
        return {
          for (final entry in stages.entries)
            if (entry.value is List)
              entry.key as String: {
                for (final (index, score) in (entry.value as List).indexed)
                  if (score is int && score > 0) index: score,
              }.lock,
        }.lock;
      },
    );
  }
}

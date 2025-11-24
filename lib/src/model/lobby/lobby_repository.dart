import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/lobby/correspondence_challenge.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/network/http.dart';

final correspondenceChallengesProvider = FutureProvider.autoDispose<IList<CorrespondenceChallenge>>(
  (Ref ref) {
    return ref.withClient((client) => LobbyRepository(client).getCorrespondenceChallenges());
  },
  name: 'CorrespondenceChallengesProvider',
);

class LobbyRepository {
  LobbyRepository(this.client);

  final LichessClient client;

  Future<void> createSeek(GameSeek seek, {required String sri}) async {
    final uri = Uri(path: '/api/board/seek', queryParameters: {'sri': sri});
    await client.postRead(uri, body: seek.requestBody);
  }

  Future<void> cancelSeek({required String sri}) async {
    final uri = Uri(path: '/api/board/seek', queryParameters: {'sri': sri});
    await client.deleteRead(uri);
  }

  Future<IList<CorrespondenceChallenge>> getCorrespondenceChallenges() {
    return client.readJsonList(
      Uri(path: '/lobby/seeks'),
      headers: {'Accept': 'application/vnd.lichess.v5+json'},
      mapper: _correspondenceSeekFromJson,
    );
  }
}

CorrespondenceChallenge _correspondenceSeekFromJson(Map<String, dynamic> json) {
  return _correspondenceSeekFromPick(pick(json).required());
}

CorrespondenceChallenge _correspondenceSeekFromPick(RequiredPick pick) {
  return CorrespondenceChallenge(
    id: pick('id').asGameIdOrThrow(),
    username: pick('username').asStringOrThrow(),
    title: pick('title').asStringOrNull(),
    rating: pick('rating').asIntOrThrow(),
    variant: pick('variant').asVariantOrThrow(),
    perf: pick('perf').asPerfOrThrow(),
    rated: pick('mode').asIntOrThrow() == 1,
    days: pick('days').asIntOrNull(),
    side: pick('color').asSideOrNull(),
    provisional: pick('provisional').asBoolOrNull(),
  );
}

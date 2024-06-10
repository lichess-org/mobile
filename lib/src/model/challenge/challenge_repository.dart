import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/json.dart';

import './challenge_request.dart';

typedef ChallengesList = ({
  IList<Challenge> inward,
  IList<Challenge> outward,
});

class ChallengeRepository {
  const ChallengeRepository(this.client);

  final LichessClient client;

  Future<ChallengesList> list() async {
    final uri = Uri(path: '/api/challenge');
    return client.readJson(
      uri,
      mapper: (json) {
        final listPick = pick(json).required();
        final inward = listPick('in').asListOrEmpty(_challengeFromPick);
        final outward = listPick('out').asListOrEmpty(_challengeFromPick);

        return (inward: inward.lock, outward: outward.lock);
      },
    );
  }

  Future<Challenge> show(ChallengeId id) async {
    final uri = Uri(path: '/api/challenge/$id/show');
    return client.readJson(
      uri,
      mapper: (json) => _challengeFromPick(pick(json).required()),
    );
  }

  Future<void> create(String username, ChallengeRequest req) async {
    final uri = Uri(path: '/api/challenge/$username');
    final response = await client.post(uri, body: req.toRequestBody);

    if (response.statusCode >= 400) {
      throw http.ClientException(
        'Failed to challenge user: ${response.statusCode}',
        uri,
      );
    }
  }

  Future<void> accept(ChallengeId id) async {
    final uri = Uri(path: '/api/challenge/$id/accept');
    final response = await client.post(uri);

    if (response.statusCode >= 400) {
      throw http.ClientException(
        'Failed to accept challenge: ${response.statusCode}',
        uri,
      );
    }
  }

  Future<void> decline(ChallengeId id) async {
    final uri = Uri(path: '/api/challenge/$id/decline');
    final response = await client.post(uri);

    if (response.statusCode >= 400) {
      throw http.ClientException(
        'Failed to decline challenge: ${response.statusCode}',
        uri,
      );
    }
  }

  Future<void> cancel(ChallengeId id) async {
    final uri = Uri(path: '/api/challenge/$id/cancel');
    final response = await client.post(uri);

    if (response.statusCode >= 400) {
      throw http.ClientException(
        'Failed to cancel challenge: ${response.statusCode}',
        uri,
      );
    }
  }
}

Challenge _challengeFromPick(RequiredPick pick) {
  final challengerUser = pick('challenger').asLightUserOrThrow();
  final destUser = pick('destUser').asLightUserOrThrow();

  return Challenge(
    id: pick('id').asChallengeIdOrThrow(),
    status: pick('status').asChallengeStatusOrThrow(),
    variant: pick('variant').asVariantOrThrow(),
    speed: pick('speed').asSpeedOrThrow(),
    timeControl: pick('timeControl').letOrThrow(
      (tcPick) => (
        type: tcPick('type').asChallengeTimeControlTypeOrThrow(),
        time: tcPick('limit').asDurationFromSecondsOrNull(),
        increment: tcPick('increment').asDurationFromSecondsOrNull(),
        days: tcPick('daysPerTurn').asIntOrNull(),
        show: tcPick('show').asBoolOrNull(),
      ),
    ),
    rated: pick('rated').asBoolOrThrow(),
    sideChoice: pick('color').asSideChoiceOrThrow(),
    finalSide: pick('finalColor').asSideOrThrow(),
    challenger: pick('challenger').letOrThrow(
      (challengerPick) => (
        user: challengerUser,
        provisionalRating: challengerPick('provisional').asBoolOrThrow(),
        lagRating: challengerPick('lag').asIntOrThrow(),
      ),
    ),
    destUser: pick('destUser').letOrThrow(
      (destPick) => (
        user: destUser,
        provisionalRating: destPick('provisional').asBoolOrThrow(),
        lagRating: destPick('lag').asIntOrThrow(),
      ),
    ),
    initialFen: pick('initialFen').asStringOrNull(),
    direction: pick('direction').asChallengeDirectionOrNull(),
  );
}

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
      mapper: (json) {
        print('challenge show json: $json');
        return _challengeFromPick(pick(json).required());
      },
    );
  }

  Future<Challenge> create(ChallengeRequest challenge) async {
    final uri = Uri(path: '/api/challenge/${challenge.destUser.id}');
    return client.postReadJson(
      uri,
      body: challenge.toRequestBody,
      mapper: (json) => _challengeFromPick(pick(json)('challenge').required()),
    );
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
  return Challenge(
    socketVersion: pick('socketVersion').asIntOrThrow(),
    id: pick('id').asChallengeIdOrThrow(),
    status: pick('status').asChallengeStatusOrThrow(),
    variant: pick('variant').asVariantOrThrow(),
    speed: pick('speed').asSpeedOrThrow(),
    timeControl:
        pick('timeControl', 'type').asChallengeTimeControlTypeOrThrow(),
    clock: pick('timeControl').letOrThrow(
      (clockPick) {
        final time = clockPick('limit').asDurationFromSecondsOrNull();
        final increment = clockPick('increment').asDurationFromSecondsOrNull();
        return time != null && increment != null
            ? (time: time, increment: increment)
            : null;
      },
    ),
    days: pick('timeControl', 'daysPerTurn').asIntOrNull(),
    rated: pick('rated').asBoolOrThrow(),
    sideChoice: pick('color').asSideChoiceOrThrow(),
    challenger: pick('challenger').letOrNull(
      (challengerPick) {
        final challengerUser = pick('challenger').asLightUserOrThrow();
        return (
          user: challengerUser,
          provisionalRating: challengerPick('provisional').asBoolOrNull(),
          lagRating: challengerPick('lag').asIntOrNull(),
        );
      },
    ),
    destUser: pick('destUser').letOrNull(
      (destPick) {
        final destUser = pick('destUser').asLightUserOrThrow();
        return (
          user: destUser,
          provisionalRating: destPick('provisional').asBoolOrNull(),
          lagRating: destPick('lag').asIntOrNull(),
        );
      },
    ),
    initialFen: pick('initialFen').asStringOrNull(),
    direction: pick('direction').asChallengeDirectionOrNull(),
    declineReason: pick('declineReasonKey').asDeclineReasonOrNull(),
  );
}

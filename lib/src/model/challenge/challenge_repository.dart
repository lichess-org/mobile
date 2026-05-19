import 'dart:async';
import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/aggregator.dart';
import 'package:lichess_mobile/src/network/http.dart';

/// A provider for [ChallengeRepository].
final challengeRepositoryProvider = Provider<ChallengeRepository>((Ref ref) {
  return ChallengeRepository(ref.watch(lichessClientProvider), ref.watch(aggregatorProvider));
}, name: 'ChallengeRepositoryProvider');

typedef ChallengesList = ({IList<Challenge> inward, IList<Challenge> outward});

class ChallengeRepository {
  const ChallengeRepository(this.client, this.aggregator);

  final LichessClient client;
  final Aggregator aggregator;

  Future<ChallengesList> list() {
    final uri = Uri(path: '/api/challenge');
    return aggregator.readJson(
      uri,
      atomicMapper: (json) {
        final listPick = pick(json).required();
        final inward = listPick('in').asListOrEmpty(Challenge.fromPick);
        final outward = listPick('out').asListOrEmpty(Challenge.fromPick);

        return (inward: inward.lock, outward: outward.lock);
      },
    );
  }

  Future<Challenge> show(ChallengeId id) {
    final uri = Uri(path: '/api/challenge/$id/show');
    return client.readJson(uri, mapper: Challenge.fromServerJson);
  }

  Future<Challenge> create(ChallengeRequest challengeReq) async {
    final uri = Uri(path: '/api/challenge/${challengeReq.destUser?.id ?? 'open'}');
    final challenge = await client.postReadJson(
      uri,
      body: challengeReq.toRequestBody,
      mapper: Challenge.fromServerJson,
    );

    // The API doesn't directly allow us to create an open challenge and also join it in one step,
    // so after having created the challenge, we immediately accept it if it's an open challenge.
    if (challengeReq.destUser == null) {
      final side = switch (challengeReq.sideChoice) {
        SideChoice.white => Side.white,
        SideChoice.black => Side.black,
        SideChoice.random => Side.values[Random().nextInt(Side.values.length)],
      };
      await accept(challenge.id, side: side);
    }

    return challenge;
  }

  Future<void> accept(ChallengeId id, {Side? side}) async {
    final uri = Uri(
      path: '/api/challenge/$id/accept',
      queryParameters: {if (side != null) 'color': side.name},
    );
    await client.postRead(uri);
  }

  Future<void> decline(ChallengeId id, {ChallengeDeclineReason? reason}) async {
    final uri = Uri(path: '/api/challenge/$id/decline');
    await client.postRead(uri, body: reason != null ? {'reason': reason.name} : null);
  }

  Future<void> cancel(ChallengeId id) async {
    final uri = Uri(path: '/api/challenge/$id/cancel');
    await client.postRead(uri);
  }
}

import 'dart:async';

import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/aggregator.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'challenge_repository.g.dart';

@Riverpod(keepAlive: true)
ChallengeRepository challengeRepository(Ref ref) {
  return ChallengeRepository(
    ref.read(lichessClientProvider),
    ref.read(aggregatorProvider),
  );
}

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

  Future<Challenge> create(ChallengeRequest challenge) {
    final uri = Uri(path: '/api/challenge/${challenge.destUser.id}');
    return client.postReadJson(
      uri,
      body: challenge.toRequestBody,
      mapper: Challenge.fromServerJson,
    );
  }

  Future<void> accept(ChallengeId id) async {
    final uri = Uri(path: '/api/challenge/$id/accept');
    await client.postRead(uri);
  }

  Future<void> decline(ChallengeId id, {ChallengeDeclineReason? reason}) async {
    final uri = Uri(path: '/api/challenge/$id/decline');
    await client.postRead(
      uri,
      body: reason != null ? {'reason': reason.name} : null,
    );
  }

  Future<void> cancel(ChallengeId id) async {
    final uri = Uri(path: '/api/challenge/$id/cancel');
    await client.postRead(uri);
  }
}

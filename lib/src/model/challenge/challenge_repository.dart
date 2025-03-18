import 'dart:async';

import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'challenge_repository.g.dart';

@Riverpod(keepAlive: true)
ChallengeRepository challengeRepository(Ref ref) {
  return ChallengeRepository(ref.read(lichessClientProvider));
}

typedef ChallengesList = ({IList<Challenge> inward, IList<Challenge> outward});

class ChallengeRepository {
  const ChallengeRepository(this.client);

  final LichessClient client;

  Future<ChallengesList> list() {
    final uri = Uri(path: '/api/challenge');
    return client.readJson(
      uri,
      mapper: (json) {
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
    final response = await client.post(uri);

    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to accept challenge: ${response.statusCode}', uri);
    }
  }

  Future<void> decline(ChallengeId id, {ChallengeDeclineReason? reason}) async {
    final uri = Uri(path: '/api/challenge/$id/decline');
    final response = await client.post(uri, body: reason != null ? {'reason': reason.name} : null);

    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to decline challenge: ${response.statusCode}', uri);
    }
  }

  Future<void> cancel(ChallengeId id) async {
    final uri = Uri(path: '/api/challenge/$id/cancel');
    final response = await client.post(uri);

    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to cancel challenge: ${response.statusCode}', uri);
    }
  }
}

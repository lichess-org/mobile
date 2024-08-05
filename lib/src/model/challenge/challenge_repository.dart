import 'dart:async';

import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/notifications/challenge_notification.dart';
import 'package:lichess_mobile/src/model/notifications/local_notification_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'challenge_repository.g.dart';

@riverpod
ChallengeRepository challengeRepository(ChallengeRepositoryRef ref) {
  return ChallengeRepository(ref.read(lichessClientProvider));
}

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
        final inward = listPick('in').asListOrEmpty(Challenge.fromPick);
        final outward = listPick('out').asListOrEmpty(Challenge.fromPick);

        return (inward: inward.lock, outward: outward.lock);
      },
    );
  }

  Future<Challenge> show(ChallengeId id) async {
    final uri = Uri(path: '/api/challenge/$id/show');
    return client.readJson(
      uri,
      mapper: Challenge.fromServerJson,
    );
  }

  Future<Challenge> create(ChallengeRequest challenge) async {
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

@Riverpod(keepAlive: true)
class Challenges extends _$Challenges {
  StreamSubscription<SocketEvent>? _subscription;

  late SocketClient _socketClient;

  @override
  Future<ChallengesList> build() async {
    _socketClient = ref.watch(socketPoolProvider).open(Uri(path: '/socket/v5'));

    _subscription?.cancel();
    _subscription = _socketClient.stream.listen(_handleSocketEvent);

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return ref.read(challengeRepositoryProvider).list();
  }

  Future<GameFullId?> accept(ChallengeId id) async {
    final repo = ref.read(challengeRepositoryProvider);

    final inward = state.value!.inward;
    final outward = state.value!.outward;
    final newInward =
        inward.remove(inward.firstWhere((challenge) => challenge.id == id));
    state = AsyncValue.data((inward: newInward, outward: outward));

    return repo
        .accept(id)
        .then((_) => repo.show(id).then((challenge) => challenge.gameFullId));
  }

  void cancel(ChallengeId id) {
    ref.read(challengeRepositoryProvider).cancel(id);
  }

  void _handleSocketEvent(SocketEvent event) {
    if (event.topic != 'challenges') return;

    final listPick = pick(event.data).required();
    final inward = listPick('in').asListOrEmpty(Challenge.fromPick);
    final outward = listPick('out').asListOrEmpty(Challenge.fromPick);

    final prevIds = state.value?.inward.map((element) => element.id) ?? [];
    // find any challenges that weren't in the inward list before
    inward
        .map((element) => element.id)
        .where((id) => !prevIds.contains(id))
        .map((id) => inward.firstWhere((element) => element.id == id))
        .forEach(_notifyUser);

    state = AsyncValue.data((inward: inward.lock, outward: outward.lock));
  }

  void _notifyUser(Challenge challenge) {
    ref.read(localNotificationServiceProvider).show(
          ChallengeNotification(challenge.id).build(
            'Challenge request from ${challenge.challenger!.user.name}',
          ),
        );
  }
}

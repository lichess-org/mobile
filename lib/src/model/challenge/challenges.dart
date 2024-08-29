import 'dart:async';

import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'challenges.g.dart';

@Riverpod(keepAlive: true)
class Challenges extends _$Challenges {
  @override
  Future<ChallengesList> build() async {
    socketGlobalStream.listen(_handleSocketEvent);

    final session = ref.watch(authSessionProvider);
    if (session == null) {
      return Future.value(
        (
          inward: const IList<Challenge>.empty(),
          outward: const IList<Challenge>.empty(),
        ),
      );
    }

    return ref.read(challengeRepositoryProvider).list();
  }

  void _handleSocketEvent(SocketEvent event) {
    if (event.topic != 'challenges') return;

    final listPick = pick(event.data).required();
    final inward = listPick('in').asListOrEmpty(Challenge.fromPick);
    final outward = listPick('out').asListOrEmpty(Challenge.fromPick);

    state = AsyncValue.data((inward: inward.lock, outward: outward.lock));
  }
}

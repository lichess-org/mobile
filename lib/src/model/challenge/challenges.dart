import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'challenges.g.dart';

@riverpod
class Challenges extends _$Challenges {
  StreamSubscription<ChallengesList>? _subscription;

  @override
  Future<ChallengesList> build() async {
    _subscription = ChallengeService.stream.listen((list) => state = AsyncValue.data(list));

    ref.onDispose(() {
      _subscription?.cancel();
    });

    final session = ref.watch(authSessionProvider);
    if (session == null) {
      return Future.value((
        inward: const IList<Challenge>.empty(),
        outward: const IList<Challenge>.empty(),
      ));
    }

    return ref.read(challengeRepositoryProvider).list();
  }
}

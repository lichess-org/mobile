import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_service.dart';

final challengesProvider = AsyncNotifierProvider.autoDispose<Challenges, ChallengesList>(
  Challenges.new,
  name: 'ChallengesProvider',
);

class Challenges extends AsyncNotifier<ChallengesList> {
  StreamSubscription<ChallengesList>? _subscription;

  @override
  Future<ChallengesList> build() {
    _subscription = ChallengeService.stream.listen((list) => state = AsyncValue.data(list));

    ref.onDispose(() {
      _subscription?.cancel();
    });

    final authUser = ref.watch(authControllerProvider);
    if (authUser == null) {
      return Future.value((
        inward: const IList<Challenge>.empty(),
        outward: const IList<Challenge>.empty(),
      ));
    }

    return ref.read(challengeRepositoryProvider).list();
  }
}
